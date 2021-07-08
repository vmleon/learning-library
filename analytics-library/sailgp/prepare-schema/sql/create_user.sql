create user sailor identified by Oracle_12345;
grant dwrole to sailor;
grant oml_developer to sailor;
grant dwrole to sailor;
--grant pyqadmin to sailor;
alter user sailor grant connect through oml$proxy;
alter user sailor quota unlimited on data;
grant create session to sailor;
grant create table to sailor;
grant create view to sailor;
grant create mining model to sailor;
grant execute on ctxsys.ctx_ddl to sailor;
grant create mining model to sailor;
grant select any mining model to sailor;
grant drop any mining model to sailor;
grant select any mining model to sailor;
grant comment any mining model to sailor;
begin
ords.enable_schema(p_enabled => true,
  p_schema => 'sailor',
  p_url_mapping_type => 'BASE_PATH',
  p_url_mapping_pattern => 'sailor',
  p_auto_rest_auth => true);
commit;
end;
/
