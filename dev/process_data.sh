#!/bin/bash
cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ../etc/config.sh

DATA=$1
OUT_DATA_FILE=/tmp/t1

regex() {
    [[ $1 =~ $2 ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}
strip_all() {
    printf '%s\n' "${1//$2}"
}
trim_all(){
    set -f
    set -- $*
    printf '%s\n' "$*"
    set +f
}
split(){
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}
read_data(){
        buf=''
        while read -r line; do
                _line="$(trim_all "$(strip_all "$line" '\\' )")"
                buf="$buf $_line"
                if ! regex "$line" '\\$'; then
                        echo -e "$(trim_all "$buf")"
                        buf=''
                fi
        done < "$1" | \
                grep -v '^$'  | \
                cut -d ' ' -f2,3,7,8,12,13-100
}
_lower(){
    printf '%s\n' "${1,,}"
}
parse_responses(){
  tf=$(mktemp)
  __query_record_type="$2"
  __query_record="$3"
  (
	echo -n '[' 
	( 
	  echo -e "$@"  | tr ' ' '\n'| grep ',IN,'|cut -d',' -f1,3,4,5 |tr ',' ' ' > $tf

		while read -r rec rec_type ttl response; do
			cmd="record=$rec record_type=$rec_type response_ttl=$ttl response=$response"
			if [[ "$rec_type" == "$__query_record_type" && "$(_lower "$rec")" == "$(_lower "$__query_record")" ]]; then	
				echo $response
			fi
	   done	<"$tf" | \
		tr '\n' ' '
	)  | tr ' ' ',' | sed 's/,$//g'
	echo -n ']'
  )
}
json_filter(){
        while read -r _date _time _dns_server _dns_client _query _response; do
                _dns_server_host="$(echo $_dns_server|cut -d'[' -f2|cut -d']' -f1)"
                _dns_client_host="$(echo $_dns_client|cut -d'[' -f2|cut -d']' -f1)"
                _query_record="$(echo $_query|cut -d',' -f1)"
                _query_record_type="$(echo $_query|cut -d',' -f3)"
		__responses="$(echo -e "$_response")"
		__responses="$(parse_responses "$__responses" "$_query_record_type" "$_query_record")"
		jo_cmd="$jo _date=$_date _time=$_time _dns_server_host=$_dns_server_host _dns_client_host=$_dns_client_host _query_record=$_query_record _query_record_type=$_query_record_type query_response_values=\"$__responses\""

		[[ "$_query_record" != "" ]] && eval $jo_cmd

		>&2 echo -e "$_response"

        done < <(command xargs -I % echo -e "%")
}

read_data "$DATA" | \
        json_filter

