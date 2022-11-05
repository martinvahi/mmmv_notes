#!/usr/bin/env bash
# This file is in public domain.

MMMV_WGET_RECURSIVE_SINGLE_DOMAIN_CMD="nice -n18 time torsocks wget --recursive \
  --convert-links --adjust-extension --page-requisites \
  --tries=3 --waitretry=2  --timeout=10 --user-agent=firefox "

MMMV_WGET_RECURSIVE_ACROSS_DOMAINS_CMD="$MMMV_WGET_RECURSIVE_SINGLE_DOMAIN_CMD -H "

S_URL="the_URL"
S_RECURSION_DEPTH="4"

$MMMV_WGET_RECURSIVE_SINGLE_DOMAIN_CMD    --level=$S_RECURSION_DEPTH $S_URL

# $MMMV_WGET_RECURSIVE_ACROSS_DOMAINS_CMD --level=$S_RECURSION_DEPTH $S_URL

