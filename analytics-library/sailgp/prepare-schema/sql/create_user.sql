create user sailor identified by Oracle_12345;
grant dwrole to sailor;
alter user sailor quota unlimited on data;
grant create session to sailor;
grant create table to sailor;
begin
ords.enable_schema(p_enabled => true,
  p_schema => 'sailor',
  p_url_mapping_type => 'BASE_PATH',
  p_url_mapping_pattern => 'sailor',
  p_auto_rest_auth => true);
commit;
end;
/
