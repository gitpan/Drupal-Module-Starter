BEGIN {

	use strict;
	use Test::More qw 'no_plan';
	use_ok('Drupal::Module::Starter');
	use_ok('YAML');
}

ok(my $s = Drupal::Module::Starter->new('t/config.yaml'));
isa_ok($s, 'Drupal::Module::Starter');
ok(my $yaml = $s->sample_yaml);
ok($y = Load($yaml), "Yaml load and parse");

is_deeply($y, {
hook_access => '0', hook_auth => '0',
hook_block => '0', hook_comment => '0',
hook_cron => '0', hook_db_rewrite_sql => '0',
hook_delete => '0', hook_exit => '0',
hook_filter => '0', hook_filter_tips => '0',
hook_footer => '0', hook_form => '0',
hook_help => '0', hook_info => '0',
hook_init => '0', hook_insert => '0',
hook_link => '0', hook_load => '0',
hook_menu => '0', hook_nodeapi => '0',
hook_node_grants => '0', hook_node_name => '1',
hook_node_types => '0', hook_onload => '0',
hook_perm => '1', hook_ping => '0',
hook_search => '0', hook_search_item => '0',
hook_search_preprocess => '0',
hook_settings => '0',
hook_taxonomy => '0',
hook_textarea => '0',
hook_update => '0',
hook_update_index => '0',
hook_user => '0',
hook_validate => '0',
hook_view => '0',
hook_xmlrpc => '0',
hook_xmlrpc => '0',
page_sample => '1',

});



