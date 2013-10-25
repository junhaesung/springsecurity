create table acl_sid (
  id bigint generated by default as identity(start with 100) not null primary key,
  principal boolean not null,
  sid varchar_ignorecase(100) not null,
  constraint uk_acl_sid unique(sid,principal) );

create table acl_class (
  id bigint generated by default as identity(start with 100) not null primary key, 
  class varchar_ignorecase(500) not null, 
  constraint uk_acl_class unique(class) );

create table acl_object_identity (
  id bigint generated by default as identity(start with 100) not null primary key, 
  object_id_class bigint not null, 
  object_id_identity bigint not null, 
  parent_object bigint, 
  owner_sid bigint not null, 
  entries_inheriting boolean not null, 
  constraint uk_acl_objid unique(object_id_class,object_id_identity), 
  constraint fk_acl_obj_parent foreign key(parent_object)references acl_object_identity(id), 
  constraint fk_acl_obj_class foreign key(object_id_class)references acl_class(id), 
  constraint fk_acl_obj_owner foreign key(owner_sid)references acl_sid(id) );

create table acl_entry ( 
  id bigint generated by default as identity(start with 100) not null primary key, 
  acl_object_identity bigint not null,
  ace_order int not null,
  sid bigint not null, 
  mask integer not null,
  granting boolean not null,
  audit_success boolean not null, 
  audit_failure boolean not null,
  constraint uk_acl_entry unique(acl_object_identity,ace_order), 
  constraint fk_acl_entry_obj_id foreign key(acl_object_identity) 
      references acl_object_identity(id), 
  constraint fk_acl_entry_sid foreign key(sid) references acl_sid(id) );

