{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writers.writeDashBin "dic" ''
      # usage: dic [--lang=LANG] WORD...
      # where LANG may be one of en, fr, es, it, ch, ru, pt, pl
      set -euf
      
      main() {
      
        _args=$(getopt -n "$0" -s sh \
            -o l: \
            -l lang: \
            -- "$@")
        if \test $? != 0; then exit 1; fi
        eval set -- "$_args"
        unset _args
        lang=en
        while :; do case $1 in
          -l|--lang) lang=$2; shift 2;;
          --) shift; break;;
        esac; done
      
        search=$*
        lp=''${lang}de
      
        GET | simplify | tac
      }
      
      GET() {
        curl -GsS \
            -b 'LEOABTEST=T; browser=webkit%3B5%3Bajax' \
            --data-urlencode lang="$lang" \
            --data-urlencode lp="$lp" \
            --data-urlencode multiwordShowSingle=on \
            --data-urlencode resultOrder=basic \
            --data-urlencode rmSearch=on \
            --data-urlencode rmWords=off \
            --data-urlencode searchLoc=0 \
            --data-urlencode search="$search" \
            --data-urlencode tolerMode=nof \
            "https://dict.leo.org/dictQuery/m-vocab/$lp/query.xml"
      }
      
      simplify() {
        sed '
          s|<repr\( [^>]*\)>|\nREPR: |g
          s|</repr>|\n|g
        ' | grep ^REPR |
        sed '
          s/^REPR: //
          1~2{s/$//}
          2~2{s/$//}
        ' |
        tr -d \\n |
        sed '
          s// [38;5;237m-[m /g
          s//\n/g
      
          s|</\?m\>[^>]*>||g
          s|</\?sr\>[^>]*>||g
          s|</\?t\>[^>]*>||g
      
          #q
      
          s/&#8660;/⇔/g
          s/&#160;/ /g; # &nbsp;
          s/&#174;/®/g;
          s/  */ /g
      
          # <!-- undefined_translation: en:pl_ext -->
          s/ *<!--[^>]*-->//g
      
          s|<i> *|/|g
          s| *</i>|/|g
      
          s:<sup>1</sup>:¹:g; s:<sup>2</sup>:²:g; s:<sup>3</sup>:³:g;
          s:<sup>:^(:g
          s:</sup>:):g
      
          s:<sub>0</sub>:₀:g;
          s:<sub>1</sub>:₁:g; s:<sub>2</sub>:₂:g; s:<sub>3</sub>:₃:g;
          s:<sub>4</sub>:₄:g; s:<sub>5</sub>:₅:g; s:<sub>6</sub>:₆:g;
          s:<sub>7</sub>:₇:g; s:<sub>8</sub>:₈:g; s:<sub>9</sub>:₉:g;
          s:<sub>:_(:g
          s:</sub>:):g
      
          s:<b> *:[;4m:g
          s: *</b>:[m:g
      
          s|<small> *||g
          s| *</small>||g
      
          s|<domain> *|[38;5;238m|g
          s| *</domain>|[m|g
      
          # "Verbtabelle" and plural
          s:<flecttabref> *:[38;5;248m:g
          s: *</flecttabref>:[m:g
      
          s:<br/>:\n:g
        '
      }
      
      usage() {
        sed -rn '/^# usage:/,/^[^#]/{/^#/{s/# //;p}}' "$0" >&2
      }
      
      main "$@"
    '')
  ];
}
