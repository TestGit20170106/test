create or replace FUNCTION RX_ONE_SPLIT
  (
    RX_SOURCE in varchar,
    SEP in varchar2,
    RX_MOD in varchar2 default ''
  )
  return RX_ONE_OUT_TABLE PIPELINED
is
  RX_FOUND_COUNT number;
  RX_FOUND_NEXT number;
BEGIN
    /*
      Fonction de recherche découpe d'une chaine de caractères selon un réparateur (regexp)

      Renvoie une table (RX_ONE_OUT_TABLE) contenant toutes les sous chaines séparés par des chaines
      correspondant à l'expression RX
    */

    --RX_FOUND_COUNT := regexp_count(RX_SOURCE, SEP,1,RX_MOD);
    $IF DBMS_DB_VERSION.version < 10
      $THEN
        $ERROR
          'Version d''oracle trop vieille '
        $END
    $END
    $IF DBMS_DB_VERSION.version = 10
      $THEN
        RX_FOUND_COUNT := length(regexp_replace(regexp_replace(RX_SOURCE, SEP, chr(12), 1, 0, RX_MOD ), '[^'||chr(12)||']', ''));
      $ELSE
        RX_FOUND_COUNT := regexp_count(RX_SOURCE, SEP, 1,RX_MOD);
    $END

    RX_FOUND_NEXT:=regexp_instr(RX_SOURCE, SEP, 1,1,0, RX_MOD);
        if(RX_FOUND_NEXT=0)
          then RX_FOUND_NEXT:=length(RX_SOURCE)+1;
        end if;
    pipe row(
          RX_ONE_OUT_RECORD(
            substr(RX_SOURCE, 0,RX_FOUND_NEXT -1),
            1,
            RX_FOUND_COUNT+1
          )
        );
    if RX_FOUND_COUNT>0
    then
      for
        RX_FOUND_NUMBER
          in 1..RX_FOUND_COUNT
      loop
        RX_FOUND_NEXT:=regexp_instr(RX_SOURCE, SEP, 1,RX_FOUND_NUMBER+1,0, RX_MOD);
        if(RX_FOUND_NEXT=0)
          then RX_FOUND_NEXT:=length(RX_SOURCE)+1;
        end if;
        pipe row(
          RX_ONE_OUT_RECORD(
            substr(
              RX_SOURCE,
              regexp_instr(RX_SOURCE, SEP, 1,RX_FOUND_NUMBER,1, RX_MOD),
              RX_FOUND_NEXT
                -regexp_instr(RX_SOURCE, SEP, 1,RX_FOUND_NUMBER,1, RX_MOD)
            ),
            RX_FOUND_NUMBER+1,
            RX_FOUND_COUNT+1
          )
        );
      end loop;

    end if;
end;
