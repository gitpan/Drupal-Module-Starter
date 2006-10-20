package Drupal::Module::Starter;

use warnings;
use strict;
use YAML;
use Drupal::Module::Starter::4_7_3;
use File::Path;

=head1 NAME

Drupal::Module::Starter - Create Drupal Module starter files


=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';

=head1 SYNOPSIS

    You probably don't want to use this module directly - you want to use the drupal-module-starter script in the scripts directory of the distribution

    use Drupal::Module::Starter;

    my $foo = Drupal::Module::Starter->new('path/to/config.yaml');
    $foo->generate;
    ...

=head1 FUNCTIONS

=head2 new - constructor - requires a YAML file path

=cut

sub new {

	my ($self, $class) = ( {}, shift );
	bless $self,$class;
	$self->{config_file} = shift or die "No config.yaml passed to constructor";
	$self->{cfg} = YAML::LoadFile($self->{config_file}) or die "Error loading YAML";
	$self->{cfg}->{drupal_version} = '4.7.3' unless $self->{cfg}->{drupal_version};
	$self->{cfg}->{author} = 'Author not set' unless $self->{cfg}->{author};
	$self->{cfg}->{email} = 'author@somesite.com' unless $self->{cfg}->{email};
    die "No module set in config" unless $self->{cfg}->{module};	
	$self->{cfg}->{drupal_version} =~ s/\./_/g;
	my $pkg = "Drupal::Module::Starter::".$self->{cfg}->{drupal_version};
	
	$self->{stubs} = $pkg->new;
	return $self;
}

=head2 sample_yaml - create a sample yaml file to use as a template

=cut

sub sample_yaml {
	return qq!---
hook_access:  0
hook_auth:  0
hook_block:  0	
hook_comment:  0	
hook_cron:  0	
hook_db_rewrite_sql:  0	
hook_delete:  0		
hook_elements:  0	
hook_exit:  0	
hook_file_download: 0
hook_filter: 0
hook_filter_tips: 0
hook_footer: 0
hook_form: 0	
hook_form_alter: 0
hook_help: 0	
hook_info: 0			
hook_init: 0	
hook_insert: 0	
hook_install: 0			
hook_link: 0	
hook_load: 0	
hook_menu: 0		
hook_nodeapi: 0		
hook_node_grants: 0	
hook_node_info: 0
hook_perm	: 0		
hook_ping: 0
hook_prepare: 0
hook_search: 0
hook_search_item: 0
hook_search_preprocess: 0	
hook_settings: 0	
hook_submit: 0	
hook_taxonomy: 0	
hook_update: 0	
hook_update_index: 0	
hook_update_N: 0	
hook_user: 0	
hook_validate: 0	
hook_view: 0		
hook_xmlrpc: 0	
!;


}




=head2 generate_php - run through the requested module hooks and generate stubs

=cut 

sub generate_php {
	my $self = shift;
	my $now = scalar(localtime);
	
	my $module = "<?php
	
/*  $self->{cfg}->{module} - Version 0.1
*   ----------------------------------------------------------
*   Author: $self->{cfg}->{author}  ($self->{cfg}->{email})
*   
*  Changelog:
*  - Version:  0.1 - generated $now
*
*/

";

	#use Data::Dumper;
	#print Dumper($self->{cfg});
	
	#exit;



	# add stub hooks
	my @hooks = keys %{$self->{stubs}};
	for my  $hook (keys %{$self->{stubs}}) {
	
		 next unless($self->{cfg}->{$hook}); 		 
		 
		 my $stub = $self->{stubs}->{$hook};
		 
		 # TODO -- add table name substitution support...
		 
		 
		 $stub =~ s/MODULENAME/$self->{cfg}->{module}/g;
		 $module .= "\n$stub\n\n";
	}

	

	$module .= "?>";
	return $module;
}

=head2 generate_readme - create a stub README.txt

=cut

sub generate_readme {
	my $self = shift;
	my $now = scalar(localtime);
	my $year = (localtime)[5]+1900;
	my $readme = qq!
---------------------------------------------------------------------------
$self->{cfg}->{module} - Version 0.0.1
---------------------------------------------------------------------------
Author: $self->{cfg}->{author}  ($self->{cfg}->{email})

(c) Copyright $year - $self->{cfg}->{author} - All Rights Reserved


Changelog - Version 0.0.1 (autogenerated $now)

!;
	return $readme;
}

=head2 generate_license - create a stub license file

=cut
sub generate_license {
	my $self = shift;
	my $lic = "License Terms go here";
	return $lic;
}

=head2 generate_install - create a stub INSTALL.txt

=cut
sub generate_install {
	my $self = shift;
	my $install = qq!
Installation instructions for $self->{cfg}->{module} 0.1
----------------------------------------------------------------------------------	
!;

}

=head2 generate_files - actually do the work and create the files if they exist

=cut
sub generate {
	my $self = shift;
	my $output_dir = $self->{cfg}->{dir}."/$self->{cfg}->{module}";
	mkpath($output_dir,0777) unless -e $output_dir;
	my $module_name = $self->{cfg}->{module}.'.module';
	my $files = {
		module 	=> [ $module_name, $self->generate_php ],
		readme 	=> [ 'README.txt',$self->generate_readme ],
		install 		=> [ 'INSTALL.txt', $self->generate_install ],
		license  	=> [ 'LICENSE.txt',$self->generate_license]
	};
	
	# do any files exist?   are we in force mode?
	for my $file (keys %$files) {
		my $path = $output_dir.'/'.$files->{$file}[0];
		if(-e $path and !$self->{cfg}->{force}) {
			die "$path already exists.  Use the 'force' directive to overwrite files";
		}
	}
	for my $file (keys %$files) {
		my $path = $output_dir.'/'.$files->{$file}[0];
		my $data = $files->{$file}[1];
		print "Opening file $file for write\n" if $self->{cfg}->{verbose};
		open(F,">$path") or die "$path: $!";
		print F $data;
		close F;		
	}

	return 1;
}

=head1 AUTHOR

Steve McNabb, C<< <smcnabb@cpan.org> >>
IT Director, F5 Site Design - http://www.f5sitedesign.com
Open Source Internet Application Development

=cut

=head1 BUGS

Please report any bugs or feature requests to
C<bug-drupal-module-starter@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Drupal-ModStarter>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Steve McNabb, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Drupal::Module::Starter