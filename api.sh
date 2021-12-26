#!/bin/bash

NOTION_API=https://api.notion.com/v1
NOTION_VERSION="2021-08-16"
NOTION_TOKEN=
DATABASE_ID=

get_blogs() {
  curl -X POST "${NOTION_API}/databases/${DATABASE_ID}/query" \
    -H "Notion-Version: ${NOTION_VERSION}" \
    -H "Authorization: Bearer ${NOTION_TOKEN}"
}

get_blog() {
  curl "${NOTION_API}/pages/${1}" \
    -H "Notion-Version: ${NOTION_VERSION}" \
    -H "Authorization: Bearer ${NOTION_TOKEN}" | jq
}

get_blocks() {
  curl "${NOTION_API}/blocks/${1}/children" \
    -H "Notion-Version: ${NOTION_VERSION}" \
    -H "Authorization: Bearer ${NOTION_TOKEN}" | jq
}

# get blocks data
for blog in $(get_blogs | jq '.results | .[] | .id')
do
  sleep 3
  # https://stackoverflow.com/questions/16154007/replace-all-double-quotes-with-single-quotes
  get_blocks $(echo $blog | sed "s/\"//g")

  sleep 3
  get_blog $(echo $blog | sed "s/\"//g")
done
