DROP INDEX rd_host_name;
CREATE INDEX rd_evt_service_name ON report_data(event_type, host_name, service_description);
