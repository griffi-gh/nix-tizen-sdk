#!/usr/bin/env nu

const origin_url = 'https://download.tizen.org/sdk/tizenstudio'
const data_dir = "data"

let parse_info = {
    decode
    | split row -r '(\n){2,}'
    | each {
        parse -r '(?P<key>[^:]+)(?: : )(?P<value>.*(?:(?:\n ).*)*)'
        | update key { str snake-case }
        | transpose -r -d
    }
}

let index_by = {|field| reduce -f {} {|it, a| $a | insert ($it | get $field) ($it | reject $field) }}

stor create -t gc_index -c { hash: str }
let db = stor open
$db | query db "CREATE UNIQUE INDEX IF NOT EXISTS gc_index_hash ON gc_index (hash)"

http get $"($origin_url)/distribution.info"
| do $parse_info
| par-each {|distribution|
    let distribution_url = $"($origin_url)/($distribution.name)"

    let os_info = http get $"($distribution_url)/os_info"
        | decode
        | str trim
        | split row "\n"

    let snapshots = http get $"($distribution_url)/snapshot.info"
        | do $parse_info
        | par-each {|snapshot|
            upsert packages {
                $os_info
                | par-each {|os|
                    let packages = http get $"($distribution_url)/snapshots/($snapshot.name)/pkg_list_($os)"
                        | do $parse_info
                    let pkg_json = $packages | to json -r
                    let pkg_hash = $pkg_json | hash md5
                    let pkg_path = $"($data_dir)/objects/($pkg_hash).json"
                    if (not ($pkg_path | path exists)) { $pkg_json | save -f $pkg_path }
                    $db | query db "INSERT INTO gc_index (hash) VALUES (?)" -p [$pkg_hash]
                    { os: $os, packages: $pkg_path }
                }
                | transpose -r -d
            }
        }
        | do $index_by name

    $distribution | upsert snapshots $snapshots
}
| do $index_by name
| to json -r
| save -f data/index.json

# gc unused objects
ls $"($data_dir)/objects" | each {|file|
    let pkg_hash = $file.name | path parse | get stem
    let alive = $db | query db "SELECT 1 FROM gc_index WHERE hash = ?" -p [$pkg_hash]
    if (($alive | length) == 0) { rm $file.name }
}
