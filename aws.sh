#!/usr/bin/env zsh

function aws-rds-describe() {
    zparseopts -D -E -A opts -- o:
    output=${opts[-o]:-"table"}

    name=${1}
    query=(
        "DBInstances[]"
        ".{"
        "DBInstanceIdentifier : DBInstanceIdentifier,"
        "Address              : Endpoint.Address,"
        "Port                 : Endpoint.Port,"
        "InstanceCreateTime   : InstanceCreateTime,"
        "DBInstanceClass      : DBInstanceClass"
        "}"
    )

    aws --output ${output} \
        rds describe-db-instances \
        --query "${query}"

}

function aws-instances-describe() {
    zparseopts -D -E -A opts -- o t:
    output=${opts[-o]:-"table"}
    tag_name=${opts[-t]:-"Name"}

    name=${1}
    query=(
        "Reservations[].Instances[]"
        ".{"
        "Name             : Tags[?Key == \`Name\`].Value | [0],"
        "State            : State.Name,"
        "LaunchTime       : LaunchTime,"
        "PrivateDnsName   : PrivateDnsName,"
        "PublicDnsName    : PublicDnsName,"
        "InstanceId       : InstanceId,"
        "InstanceType     : InstanceType"
        "}"
    )

    aws --output ${output} \
        ec2 describe-instances \
        --filters "Name=tag:${tag_name},Values=*${name}*" \
        --query "${query}"
}

