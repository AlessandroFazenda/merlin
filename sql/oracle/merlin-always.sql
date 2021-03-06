DROP SEQUENCE comment_tbl_id_SEQ;
CREATE SEQUENCE  comment_tbl_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE contact_id_SEQ;
CREATE SEQUENCE  contact_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE service_id_SEQ;
CREATE SEQUENCE  service_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE servicedependency_id_SEQ;
CREATE SEQUENCE  servicedependency_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE serviceescalation_id_SEQ;
CREATE SEQUENCE  serviceescalation_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE scheduled_downtime_id_SEQ;
CREATE SEQUENCE  scheduled_downtime_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE hostescalation_id_SEQ;
CREATE SEQUENCE  hostescalation_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE servicegroup_id_SEQ;
CREATE SEQUENCE  servicegroup_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE command_id_SEQ;
CREATE SEQUENCE  command_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE host_id_SEQ;
CREATE SEQUENCE  host_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE contactgroup_id_SEQ;
CREATE SEQUENCE  contactgroup_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE timeperiod_id_SEQ;
CREATE SEQUENCE  timeperiod_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE hostdependency_id_SEQ;
CREATE SEQUENCE  hostdependency_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP SEQUENCE rename_log_id_SEQ;
PROMPT Creating Sequence rename_log_id_SEQ ...
CREATE SEQUENCE rename_log_id_SEQ
  MINVALUE 1 MAXVALUE 999999999999999999999999 INCREMENT BY 1  NOCYCLE ;

DROP TABLE command CASCADE CONSTRAINTS;
CREATE TABLE command (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  command_name VARCHAR2(1024 CHAR) NOT NULL,
  command_line CLOB NOT NULL
);
ALTER TABLE command ADD CONSTRAINT PRIMARY PRIMARY KEY (id) ENABLE;
CREATE UNIQUE INDEX c_command_name ON command(command_name);

DROP TABLE comment_tbl CASCADE CONSTRAINTS;
CREATE TABLE comment_tbl (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  host_name VARCHAR2(255 CHAR),
  service_description VARCHAR2(255 CHAR),
  comment_type NUMBER(10,0),
  entry_time NUMBER(10,0),
  author_name VARCHAR2(255 CHAR),
  comment_data CLOB,
  persistent NUMBER(3,0),
  source NUMBER(10,0),
  entry_type NUMBER(10,0),
  expires NUMBER(10,0),
  expire_time NUMBER(10,0),
  comment_id NUMBER(10,0) NOT NULL
);
ALTER TABLE comment_tbl ADD CONSTRAINT PRIMARY_5 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX c_comment_id ON comment_tbl(comment_id);
CREATE INDEX c_host_name ON comment_tbl(host_name);
CREATE INDEX c_service_name ON comment_tbl(host_name, service_description);

DROP TABLE contact CASCADE CONSTRAINTS;
CREATE TABLE contact (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  contact_name VARCHAR2(255 CHAR),
  alias VARCHAR2(160 CHAR) NOT NULL,
  host_notifications_enabled NUMBER(3,0),
  service_notifications_enabled NUMBER(3,0),
  can_submit_commands NUMBER(3,0),
  retain_status_information NUMBER(3,0),
  retain_nonstatus_information NUMBER(3,0),
  host_notification_period NUMBER(10,0),
  service_notification_period NUMBER(10,0),
  host_notification_options VARCHAR2(15 CHAR),
  service_notification_options VARCHAR2(15 CHAR),
  host_notification_commands CLOB,
  service_notification_commands CLOB,
  email VARCHAR2(60 CHAR),
  pager VARCHAR2(18 CHAR),
  address1 VARCHAR2(100 CHAR),
  address2 VARCHAR2(100 CHAR),
  address3 VARCHAR2(100 CHAR),
  address4 VARCHAR2(100 CHAR),
  address5 VARCHAR2(100 CHAR),
  address6 VARCHAR2(100 CHAR),
  last_host_notification NUMBER(10,0),
  last_service_notification NUMBER(10,0)
);
ALTER TABLE contact ADD CONSTRAINT PRIMARY_10 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX c_contact_name ON contact(contact_name);

DROP TABLE contact_access CASCADE CONSTRAINTS;
CREATE TABLE contact_access (
  contact NUMBER(10,0) NOT NULL,
  host NUMBER(10,0),
  service NUMBER(10,0)
);
CREATE INDEX ca_c ON contact_access(contact);
CREATE INDEX ca_cs ON contact_access(contact, service);
CREATE INDEX ca_ch ON contact_access(contact, host);

DROP TABLE contact_contactgroup CASCADE CONSTRAINTS;
CREATE TABLE contact_contactgroup (
  contact NUMBER(10,0) NOT NULL,
  contactgroup NUMBER(10,0) NOT NULL
);



DROP TABLE contactgroup CASCADE CONSTRAINTS;
CREATE TABLE contactgroup (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  contactgroup_name VARCHAR2(255 CHAR) NOT NULL,
  alias VARCHAR2(160 CHAR) NOT NULL
);
ALTER TABLE contactgroup ADD CONSTRAINT PRIMARY_9 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX contactgroup_name ON contactgroup(contactgroup_name);

DROP TABLE custom_vars CASCADE CONSTRAINTS;
CREATE TABLE custom_vars (
  obj_type VARCHAR2(30 CHAR) NOT NULL,
  obj_id NUMBER(10,0) NOT NULL,
  variable VARCHAR2(100 CHAR),
  value VARCHAR2(255 CHAR)
);
CREATE UNIQUE INDEX cv_objvar ON custom_vars(obj_type, obj_id, variable);

DROP TABLE db_version CASCADE CONSTRAINTS;
CREATE TABLE db_version (
  version NUMBER(10,0)
);

INSERT INTO db_version(version) VALUES(3);
commit;

DROP TABLE host CASCADE CONSTRAINTS;
CREATE TABLE host (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  host_name VARCHAR2(255 CHAR),
  alias VARCHAR2(100 CHAR) DEFAULT NULL, -- should be NOT NULL, but is DEFAULT NULL for compat. with a MySQL bug.
  display_name VARCHAR2(100 CHAR),
  address VARCHAR2(75 CHAR) DEFAULT NULL,  -- should be NOT NULL, but is DEFAULT NULL for compat. with a MySQL bug.
  initial_state VARCHAR2(18 CHAR),
  check_command VARCHAR2(4000 CHAR),
  max_check_attempts NUMBER(5,0),
  check_interval NUMBER(5,0),
  retry_interval NUMBER(5,0),
  active_checks_enabled NUMBER(3,0),
  passive_checks_enabled NUMBER(3,0),
  check_period VARCHAR2(255 CHAR),
  obsess_over_host NUMBER(3,0),
  check_freshness NUMBER(3,0),
  freshness_threshold FLOAT,
  event_handler NUMBER(10,0),
  event_handler_args CLOB,
  event_handler_enabled NUMBER(3,0),
  low_flap_threshold FLOAT,
  high_flap_threshold FLOAT,
  flap_detection_enabled NUMBER(3,0),
  flap_detection_options VARCHAR2(18 CHAR),
  process_perf_data NUMBER(3,0),
  retain_status_information NUMBER(3,0),
  retain_nonstatus_information NUMBER(3,0),
  notification_interval NUMBER(12,0),
  first_notification_delay NUMBER(10,0),
  notification_period VARCHAR2(255 CHAR),
  notification_options VARCHAR2(15 CHAR),
  notifications_enabled NUMBER(3,0),
  stalking_options VARCHAR2(15 CHAR),
  notes VARCHAR2(255 CHAR),
  notes_url VARCHAR2(255 CHAR),
  action_url VARCHAR2(255 CHAR),
  icon_image VARCHAR2(60 CHAR),
  icon_image_alt VARCHAR2(60 CHAR),
  statusmap_image VARCHAR2(60 CHAR),
  failure_prediction_enabled NUMBER(3,0),
  problem_has_been_acknowledged NUMBER(10,0) DEFAULT '0' NOT NULL,
  acknowledgement_type NUMBER(10,0) DEFAULT '0' NOT NULL,
  check_type NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_state NUMBER(10,0) DEFAULT '6' NOT NULL,
  last_state NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_hard_state NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_notification NUMBER(10,0) DEFAULT '0' NOT NULL,
  output CLOB,
  long_output CLOB,
  perf_data CLOB,
  state_type NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_attempt NUMBER(10,0) DEFAULT '0' NOT NULL,
  latency FLOAT,
  execution_time FLOAT,
  is_executing NUMBER(10,0) DEFAULT '0' NOT NULL,
  check_options NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_host_notification NUMBER(10,0),
  next_host_notification NUMBER(10,0),
  next_check NUMBER(10,0),
  should_be_scheduled NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_check NUMBER(10,0),
  last_state_change NUMBER(10,0),
  last_hard_state_change NUMBER(10,0),
  last_time_up NUMBER(10,0),
  last_time_down NUMBER(10,0),
  last_time_unreachable NUMBER(10,0),
  has_been_checked NUMBER(10,0) DEFAULT '0' NOT NULL,
  is_being_freshened NUMBER(10,0) DEFAULT '0' NOT NULL,
  notified_on_down NUMBER(10,0) DEFAULT '0' NOT NULL,
  notified_on_unreachable NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_notification_number NUMBER(10,0) DEFAULT '0' NOT NULL,
  no_more_notifications NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_notification_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  check_flapping_recovery_notifi NUMBER(10,0) DEFAULT '0' NOT NULL,
  scheduled_downtime_depth NUMBER(10,0) DEFAULT '0' NOT NULL,
  pending_flex_downtime NUMBER(10,0) DEFAULT '0' NOT NULL,
  is_flapping NUMBER(10,0) DEFAULT '0' NOT NULL,
  flapping_comment_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  percent_state_change FLOAT,
  total_services NUMBER(10,0) DEFAULT '0' NOT NULL,
  total_service_check_interval NUMBER(10,0) DEFAULT '0' NOT NULL,
  modified_attributes NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_problem_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_problem_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  max_attempts NUMBER(10,0) DEFAULT '1' NOT NULL,
  current_event_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_event_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  process_performance_data NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_update NUMBER(10,0) DEFAULT '0' NOT NULL,
  timeout NUMBER(10,0),
  start_time NUMBER(10,0),
  end_time NUMBER(10,0),
  early_timeout NUMBER(5,0),
  return_code NUMBER(5,0)
);
ALTER TABLE host ADD CONSTRAINT PRIMARY_4 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX h_host_name ON host(host_name);
CREATE INDEX hst_dt ON host(scheduled_downtime_depth);
CREATE INDEX hst_checks_enabled ON host(active_checks_enabled);
CREATE INDEX hst_problem_ack ON host(problem_has_been_acknowledged);
CREATE INDEX hst_flap_det_en ON host(flap_detection_enabled);
CREATE INDEX hst_is_flapping ON host(is_flapping);
CREATE INDEX hst_notif_en ON host(notifications_enabled);
CREATE INDEX hst_ev_hndl_en ON host(event_handler_enabled);
CREATE INDEX hst_psv_checks_en ON host(passive_checks_enabled);
CREATE INDEX hst_check_type ON host(check_type);
CREATE INDEX hst_latency ON host(latency);
CREATE INDEX hst_exectime ON host(execution_time);
CREATE INDEX hst_cur_state ON host(current_state);

DROP TABLE host_contact CASCADE CONSTRAINTS;
CREATE TABLE host_contact (
  host NUMBER(10,0) NOT NULL,
  contact NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX hc_host_contact ON host_contact(host, contact);

DROP TABLE host_contactgroup CASCADE CONSTRAINTS;
CREATE TABLE host_contactgroup (
  host NUMBER(10,0) NOT NULL,
  contactgroup NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX hcg_host_contactgrouop ON host_contactgroup(host, contactgroup);

DROP TABLE host_hostgroup CASCADE CONSTRAINTS;
CREATE TABLE host_hostgroup (
  host NUMBER(10,0) NOT NULL,
  hostgroup NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX hhg_h_hg ON host_hostgroup(host, hostgroup);
CREATE INDEX hhg_h ON host_hostgroup(host);
CREATE INDEX hhg_hg ON host_hostgroup(hostgroup);

DROP TABLE host_parents CASCADE CONSTRAINTS;
CREATE TABLE host_parents (
  host NUMBER(10,0) NOT NULL,
  parents NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX hp_host_parents ON host_parents(host, parents);
CREATE INDEX hp_host ON host_parents(host);
CREATE INDEX hp_parents ON host_parents(parents);

DROP TABLE hostdependency CASCADE CONSTRAINTS;
CREATE TABLE hostdependency (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  host_name NUMBER(10,0) NOT NULL,
  dependent_host_name NUMBER(10,0) NOT NULL,
  dependency_period VARCHAR2(255 CHAR),
  inherits_parent NUMBER(3,0),
  execution_failure_options VARCHAR2(15 CHAR),
  notification_failure_options VARCHAR2(15 CHAR)
);
ALTER TABLE hostdependency ADD CONSTRAINT PRIMARY_13 PRIMARY KEY(id)ENABLE;

DROP TABLE hostescalation CASCADE CONSTRAINTS;
CREATE TABLE hostescalation (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  host_name NUMBER(10,0) NOT NULL,
  first_notification NUMBER(10,0),
  last_notification NUMBER(10,0),
  notification_interval NUMBER(10,0),
  escalation_period VARCHAR2(255 CHAR),
  escalation_options VARCHAR2(15 CHAR)
);
ALTER TABLE hostescalation ADD CONSTRAINT PRIMARY_2 PRIMARY KEY(id) ENABLE;

DROP TABLE hostescalation_contact CASCADE CONSTRAINTS;
CREATE TABLE hostescalation_contact (
  hostescalation NUMBER(10,0) NOT NULL,
  contact NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX hec_he_c ON hostescalation_contact(hostescalation, contact);

DROP TABLE hostescalation_contactgroup CASCADE CONSTRAINTS;
CREATE TABLE hostescalation_contactgroup (
  hostescalation NUMBER(10,0) NOT NULL,
  contactgroup NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX hecg_he_cg ON hostescalation_contactgroup(hostescalation, contactgroup);

DROP TABLE hostgroup CASCADE CONSTRAINTS;
CREATE TABLE hostgroup (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  hostgroup_name VARCHAR2(255 CHAR),
  alias VARCHAR2(160 CHAR),
  notes VARCHAR2(160 CHAR),
  notes_url VARCHAR2(160 CHAR),
  action_url VARCHAR2(160 CHAR)
);
ALTER TABLE hostgroup ADD CONSTRAINT PRIMARY_15 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX hostgroup_name ON hostgroup(hostgroup_name);

DROP TABLE program_status CASCADE CONSTRAINTS;
CREATE TABLE program_status (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  instance_name VARCHAR2(255 CHAR),
  is_running NUMBER(3,0),
  last_alive NUMBER(10,0),
  program_start NUMBER(10,0),
  pid NUMBER(10,0),
  daemon_mode NUMBER(3,0),
  last_command_check NUMBER(10,0),
  last_log_rotation NUMBER(10,0),
  notifications_enabled NUMBER(3,0),
  active_service_checks_enabled NUMBER(3,0),
  passive_service_checks_enabled NUMBER(3,0),
  active_host_checks_enabled NUMBER(3,0),
  passive_host_checks_enabled NUMBER(3,0),
  event_handlers_enabled NUMBER(3,0),
  flap_detection_enabled NUMBER(3,0),
  failure_prediction_enabled NUMBER(3,0),
  process_performance_data NUMBER(3,0),
  obsess_over_hosts NUMBER(3,0),
  obsess_over_services NUMBER(3,0),
  check_host_freshness NUMBER(3,0),
  check_service_freshness NUMBER(3,0),
  modified_host_attributes NUMBER(10,0),
  modified_service_attributes NUMBER(10,0),
  global_host_event_handler CLOB,
  global_service_event_handler CLOB,
  peer_id NUMBER(10,0),
  node_type NUMBER(6,0),
  config_hash VARCHAR2(255 CHAR),
  self_assigned_peer_id NUMBER(10,0),
  active_peers NUMBER(10,0),
  configured_peers NUMBER(10,0),
  active_pollers NUMBER(10,0),
  configured_pollers NUMBER(10,0),
  active_masters NUMBER(10,0),
  configured_masters NUMBER(10,0),
  host_checks_handled NUMBER(10,0),
  service_checks_handled NUMBER(10,0)
);
ALTER TABLE program_status ADD CONSTRAINT PRIMARY_7 PRIMARY KEY(instance_id) ENABLE;

DROP TABLE scheduled_downtime CASCADE CONSTRAINTS;
CREATE TABLE scheduled_downtime (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  downtime_type NUMBER(10,0),
  host_name VARCHAR2(255 CHAR),
  service_description VARCHAR2(255 CHAR),
  entry_time NUMBER(10,0),
  author_name VARCHAR2(255 CHAR),
  comment_data CLOB,
  start_time NUMBER(10,0),
  end_time NUMBER(10,0),
  fixed NUMBER(3,0),
  duration NUMBER(10,0),
  triggered_by NUMBER(10,0),
  downtime_id NUMBER(10,0) NOT NULL
);
ALTER TABLE scheduled_downtime ADD CONSTRAINT PRIMARY_16 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX sd_downtime_id ON scheduled_downtime(downtime_id);
CREATE INDEX sd_host_name ON scheduled_downtime(host_name);
CREATE INDEX sd_service_name ON scheduled_downtime(host_name, service_description);

DROP TABLE service CASCADE CONSTRAINTS;
CREATE TABLE service (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  host_name VARCHAR2(255 CHAR) DEFAULT NULL,  -- should be NOT NULL, but is DEFAULT NULL for compat. with a MySQL bug.
  service_description VARCHAR2(255 CHAR) NOT NULL,
  display_name VARCHAR2(160 CHAR),
  is_volatile NUMBER(3,0),
  check_command CLOB,
  initial_state VARCHAR2(1 CHAR),
  max_check_attempts NUMBER(5,0),
  check_interval NUMBER(5,0),
  retry_interval NUMBER(5,0),
  active_checks_enabled NUMBER(3,0),
  passive_checks_enabled NUMBER(3,0),
  check_period VARCHAR2(255 CHAR),
  parallelize_check NUMBER(3,0),
  obsess_over_service NUMBER(3,0),
  check_freshness NUMBER(3,0),
  freshness_threshold NUMBER(10,0),
  event_handler NUMBER(10,0),
  event_handler_args CLOB,
  event_handler_enabled NUMBER(3,0),
  low_flap_threshold FLOAT,
  high_flap_threshold FLOAT,
  flap_detection_enabled NUMBER(3,0),
  flap_detection_options VARCHAR2(18 CHAR),
  process_perf_data NUMBER(3,0),
  retain_status_information NUMBER(3,0),
  retain_nonstatus_information NUMBER(3,0),
  notification_interval NUMBER(10,0),
  first_notification_delay NUMBER(10,0),
  notification_period VARCHAR2(255 CHAR),
  notification_options VARCHAR2(15 CHAR),
  notifications_enabled NUMBER(3,0),
  stalking_options VARCHAR2(15 CHAR),
  notes VARCHAR2(255 CHAR),
  notes_url VARCHAR2(255 CHAR),
  action_url VARCHAR2(255 CHAR),
  icon_image VARCHAR2(60 CHAR),
  icon_image_alt VARCHAR2(60 CHAR),
  failure_prediction_enabled NUMBER(3,0),
  problem_has_been_acknowledged NUMBER(10,0) DEFAULT '0' NOT NULL,
  acknowledgement_type NUMBER(10,0) DEFAULT '0' NOT NULL,
  host_problem_at_last_check NUMBER(10,0) DEFAULT '0' NOT NULL,
  check_type NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_state NUMBER(10,0) DEFAULT '6' NOT NULL,
  last_state NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_hard_state NUMBER(10,0) DEFAULT '0' NOT NULL,
  output CLOB,
  long_output CLOB,
  perf_data CLOB,
  state_type NUMBER(10,0) DEFAULT '0' NOT NULL,
  next_check NUMBER(10,0),
  should_be_scheduled NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_check NUMBER(10,0),
  current_attempt NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_event_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_event_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_problem_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_problem_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_notification NUMBER(10,0),
  next_notification NUMBER(10,0),
  no_more_notifications NUMBER(10,0) DEFAULT '0' NOT NULL,
  check_flapping_recovery_notifi NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_state_change NUMBER(10,0),
  last_hard_state_change NUMBER(10,0),
  last_time_ok NUMBER(10,0),
  last_time_warning NUMBER(10,0),
  last_time_unknown NUMBER(10,0),
  last_time_critical NUMBER(10,0),
  has_been_checked NUMBER(10,0) DEFAULT '0' NOT NULL,
  is_being_freshened NUMBER(10,0) DEFAULT '0' NOT NULL,
  notified_on_unknown NUMBER(10,0) DEFAULT '0' NOT NULL,
  notified_on_warning NUMBER(10,0) DEFAULT '0' NOT NULL,
  notified_on_critical NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_notification_number NUMBER(10,0) DEFAULT '0' NOT NULL,
  current_notification_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  latency FLOAT,
  execution_time FLOAT,
  is_executing NUMBER(10,0) DEFAULT '0' NOT NULL,
  check_options NUMBER(10,0) DEFAULT '0' NOT NULL,
  scheduled_downtime_depth NUMBER(10,0) DEFAULT '0' NOT NULL,
  pending_flex_downtime NUMBER(10,0) DEFAULT '0' NOT NULL,
  is_flapping NUMBER(10,0) DEFAULT '0' NOT NULL,
  flapping_comment_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  percent_state_change FLOAT,
  modified_attributes NUMBER(10,0) DEFAULT '0' NOT NULL,
  max_attempts NUMBER(10,0) DEFAULT '0' NOT NULL,
  process_performance_data NUMBER(10,0) DEFAULT '0' NOT NULL,
  last_update NUMBER(10,0) DEFAULT '0' NOT NULL,
  timeout NUMBER(10,0),
  start_time NUMBER(10,0),
  end_time NUMBER(10,0),
  early_timeout NUMBER(5,0),
  return_code NUMBER(5,0)
);
ALTER TABLE service ADD CONSTRAINT PRIMARY_11 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX s_service_name ON service(host_name, service_description);
CREATE INDEX svc_dt ON service(scheduled_downtime_depth);
CREATE INDEX svc_checks_enabled ON service(active_checks_enabled);
CREATE INDEX svc_problem_ack ON service(problem_has_been_acknowledged);
CREATE INDEX svc_flap_det_en ON service(flap_detection_enabled);
CREATE INDEX svc_is_flapping ON service(is_flapping);
CREATE INDEX svc_notif_en ON service(notifications_enabled);
CREATE INDEX svc_ev_hndl_en ON service(event_handler_enabled);
CREATE INDEX svc_psv_checks_en ON service(passive_checks_enabled);
CREATE INDEX svc_check_type ON service(check_type);
CREATE INDEX svc_latency ON service(latency);
CREATE INDEX svc_exectime ON service(execution_time);
CREATE INDEX svc_cur_state ON service(current_state);

DROP TABLE service_contact CASCADE CONSTRAINTS;
CREATE TABLE service_contact (
  service NUMBER(10,0) NOT NULL,
  contact NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX sc_service_contact ON service_contact(service, contact);

DROP TABLE service_contactgroup CASCADE CONSTRAINTS;
CREATE TABLE service_contactgroup (
  service NUMBER(10,0) NOT NULL,
  contactgroup NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX scg_s_cg ON service_contactgroup(service, contactgroup);

DROP TABLE service_servicegroup CASCADE CONSTRAINTS;
CREATE TABLE service_servicegroup (
  service NUMBER(10,0) NOT NULL,
  servicegroup NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX ssg_s_sg ON service_servicegroup(service, servicegroup);
CREATE INDEX ssg_s ON service_servicegroup(service);
CREATE INDEX ssg_sg ON service_servicegroup(servicegroup);

DROP TABLE servicedependency CASCADE CONSTRAINTS;
CREATE TABLE servicedependency (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  service NUMBER(10,0) NOT NULL,
  dependent_service NUMBER(10,0) NOT NULL,
  dependency_period VARCHAR2(255 CHAR),
  inherits_parent NUMBER(3,0),
  execution_failure_options VARCHAR2(15 CHAR),
  notification_failure_options VARCHAR2(15 CHAR)
);
ALTER TABLE servicedependency ADD CONSTRAINT PRIMARY_6 PRIMARY KEY(id) ENABLE;

DROP TABLE serviceescalation CASCADE CONSTRAINTS;
CREATE TABLE serviceescalation (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  service NUMBER(10,0) NOT NULL,
  first_notification NUMBER(12,0),
  last_notification NUMBER(12,0),
  notification_interval NUMBER(12,0),
  escalation_period VARCHAR2(255 CHAR),
  escalation_options VARCHAR2(15 CHAR)
);
ALTER TABLE serviceescalation ADD CONSTRAINT PRIMARY_3 PRIMARY KEY(id) ENABLE;

DROP TABLE serviceescalation_contact CASCADE CONSTRAINTS;
CREATE TABLE serviceescalation_contact (
  serviceescalation NUMBER(10,0) NOT NULL,
  contact NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX sec_se_c ON serviceescalation_contact(serviceescalation, contact);

DROP TABLE serviceescalation_contactgroup CASCADE CONSTRAINTS;
CREATE TABLE serviceescalation_contactgroup (
  serviceescalation NUMBER(10,0) NOT NULL,
  contactgroup NUMBER(10,0) NOT NULL
);
CREATE UNIQUE INDEX secg_se_cg ON serviceescalation_contactgroup(serviceescalation, contactgroup);

DROP TABLE servicegroup CASCADE CONSTRAINTS;
CREATE TABLE servicegroup (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  servicegroup_name VARCHAR2(255 CHAR) NOT NULL,
  alias VARCHAR2(160 CHAR) NOT NULL,
  notes VARCHAR2(160 CHAR),
  notes_url VARCHAR2(160 CHAR),
  action_url VARCHAR2(160 CHAR)
);
ALTER TABLE servicegroup ADD CONSTRAINT PRIMARY_12 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX s_servicegroup_name ON servicegroup(servicegroup_name);

DROP TABLE timeperiod CASCADE CONSTRAINTS;
CREATE TABLE timeperiod (
  instance_id NUMBER(10,0) DEFAULT '0' NOT NULL,
  id NUMBER(10,0) NOT NULL,
  timeperiod_name VARCHAR2(255 CHAR) NOT NULL,
  alias VARCHAR2(160 CHAR) NOT NULL,
  sunday VARCHAR2(255 CHAR),
  monday VARCHAR2(255 CHAR),
  tuesday VARCHAR2(255 CHAR),
  wednesday VARCHAR2(255 CHAR),
  thursday VARCHAR2(255 CHAR),
  friday VARCHAR2(255 CHAR),
  saturday VARCHAR2(255 CHAR)
);
ALTER TABLE timeperiod ADD CONSTRAINT PRIMARY_1 PRIMARY KEY(id) ENABLE;
CREATE UNIQUE INDEX t_timeperiod_name ON timeperiod(timeperiod_name);

DROP TABLE timeperiod_exclude CASCADE CONSTRAINTS;
CREATE TABLE timeperiod_exclude (
  timeperiod NUMBER(10,0) NOT NULL,
  exclude NUMBER(10,0) NOT NULL
);


CREATE OR REPLACE TRIGGER comment_tbl_id_TRG BEFORE INSERT OR UPDATE ON comment_tbl
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  comment_tbl_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM comment_tbl;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT comment_tbl_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER contact_id_TRG BEFORE INSERT OR UPDATE ON contact
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  contact_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM contact;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT contact_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER service_id_TRG BEFORE INSERT OR UPDATE ON service
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  service_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM service;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT service_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER servicedependency_id_TRG BEFORE INSERT OR UPDATE ON servicedependency
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  servicedependency_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM servicedependency;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT servicedependency_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER serviceescalation_id_TRG BEFORE INSERT OR UPDATE ON serviceescalation
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  serviceescalation_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM serviceescalation;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT serviceescalation_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER scheduled_downtime_id_TRG BEFORE INSERT OR UPDATE ON scheduled_downtime
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  scheduled_downtime_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM scheduled_downtime;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT scheduled_downtime_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER hostescalation_id_TRG BEFORE INSERT OR UPDATE ON hostescalation
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  hostescalation_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM hostescalation;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT hostescalation_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER servicegroup_id_TRG BEFORE INSERT OR UPDATE ON servicegroup
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  servicegroup_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM servicegroup;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT servicegroup_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER command_id_TRG BEFORE INSERT OR UPDATE ON command
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  command_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM command;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT command_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER host_id_TRG BEFORE INSERT OR UPDATE ON host
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  host_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM host;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT host_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER contactgroup_id_TRG BEFORE INSERT OR UPDATE ON contactgroup
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  contactgroup_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM contactgroup;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT contactgroup_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER timeperiod_id_TRG BEFORE INSERT OR UPDATE ON timeperiod
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  timeperiod_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM timeperiod;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT timeperiod_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

CREATE OR REPLACE TRIGGER hostdependency_id_TRG BEFORE INSERT OR UPDATE ON hostdependency
FOR EACH ROW
DECLARE
v_newVal NUMBER(12) := 0;
v_incval NUMBER(12) := 0;
BEGIN
  IF INSERTING AND :new.id IS NULL THEN
    SELECT  hostdependency_id_SEQ.NEXTVAL INTO v_newVal FROM DUAL;
    -- If this is the first time this table have been inserted into (sequence == 1)
    IF v_newVal = 1 THEN
      --get the max indentity value from the table
      SELECT NVL(max(id),0) INTO v_newVal FROM hostdependency;
      v_newVal := v_newVal + 1;
      --set the sequence to that value
      LOOP
           EXIT WHEN v_incval>=v_newVal;
           SELECT hostdependency_id_SEQ.nextval INTO v_incval FROM dual;
      END LOOP;
    END IF;
    --used to emulate LAST_INSERT_ID()
    --mysql_utilities.identity := v_newVal;
   -- assign the value from the sequence to emulate the identity column
   :new.id := v_newVal;
  END IF;
END;

/

-- DISCONNECT;
SPOOL OFF;
-- exit
;
