/* variables provided by Nagios and required by module */
#include <nagios/nagios.h>
#include <nagios/macros.h>
#include <nagios/comments.h>
#include <nagios/downtime.h>
char *config_file = "/opt/monitor/etc/nagios.cfg";
nagios_comment *comment_list = NULL;
service *service_list = NULL;
timeperiod **timeperiod_ary = NULL;
hostgroup *hostgroup_list = NULL;
host *host_list = NULL;
scheduled_downtime *scheduled_downtime_list = NULL;
#define macro_x global_macros.x
unsigned long event_broker_options = 0;
int daemon_dumps_core = 0;
sched_info scheduling_info;
#define num_hosts scheduling_info.total_hosts
#define num_services scheduling_info.total_services
int __nagios_object_structure_version = CURRENT_OBJECT_STRUCTURE_VERSION;

struct object_count num_objects;

iobroker_set *nagios_iobs = NULL;

static nagios_macros global_macros;

int qh_register_handler(const char *name, const char *description, unsigned int options, qh_handler handler)
{
	return 0;
}
int add_new_comment(int comment_type, int entry_type, char *host_name, char *service_description, time_t entry_time, char *author_name, char *comment_data, int persistent, int source, int expires, time_t expire_time, unsigned long *comment_id)
{
	return 0;
}
nagios_comment *get_first_comment_by_host(char *host_name)
{
	return 0;
}
nagios_comment *get_first_comment_by_service(char *host_name, char *service_description)
{
	return 0;
}
int delete_comment(int type, unsigned long comment_type) { return 0; }
nagios_macros *get_global_macros(void)
{
	return &global_macros;
}

/* nagios functions we must have for dlopen() to work properly */
timed_event *schedule_new_event(int a, int b, time_t c, int d, unsigned long e,
					   void *f, int g, void *h, void *i, int j)
{
	return 0;
}
host *find_host(const char *host_name)
{
	return NULL;
}
service *find_service(const char *host_name, const char *service_description)
{
	return NULL;
}
int update_all_status_data(void)
{
	return 0;
}
int process_external_command2(int cmd_id, time_t entry_time, char *args)
{
	return 0;
}
int update_host_performance_data(host *hst)
{
	return 0;
}
int update_service_performance_data(host *hst)
{
	return 0;
}
void xodtemplate_grab_config_info(void)
{
	macro_x[MACRO_OBJECTCACHEFILE] = "/opt/monitor/etc/nagios.cfg";
}

int unschedule_downtime(int type, unsigned long downtime_id)
{
	return 0;
}
int delete_downtime_by_hostname_service_description_start_time_comment
	(char *hname, char *sdesc, time_t stime, char *comment)
{
	return 0;
}

void fcache_timeperiod(FILE *fp, timeperiod *temp_timeperiod) {
	return;
}
