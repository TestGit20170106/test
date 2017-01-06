SELECT
  id_correspondance Id,
  code_correspondance Code,
  nom_correspondance Label,
  fichier_defaut DefaultExcelFileName,
  fichier_recherche ExcelFindPattern,
  flag_syndic Syndic,
  flag_gerance Gerance,
  DECODE(table_defaut, NULL, NULL, 'A$'
  || table_defaut) DefaultCorrTable,
  vue_defaut DefaultCorrView,
  vue_extract1 ExtractView1,
  vue_extract2 ExtractView2,
  col_extract ExtractRequiredFields
FROM
  am_Correspondances
