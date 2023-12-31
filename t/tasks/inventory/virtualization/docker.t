#!/usr/bin/perl

use strict;
use warnings;
use lib 't/lib';

use Test::Deep;
use Test::Exception;
use Test::More;
use Test::NoWarnings;
use Cpanel::JSON::XS;

use GLPI::Test::Inventory;
use GLPI::Agent::Tools::Virtualization;
use GLPI::Agent::Task::Inventory::Virtualization::Docker;

plan tests => 2;

my @expectedList = (
    'str1',
    'str2',
    'str3',
    '',
    'str5',
    'str6'
);

my @inputList = (
    'str1',
    'str2',
    'str3',
    'str5',
    'str6',
    ''
);

my $test = [
        {
            UUID => '7938ef110db9',
            IMAGE=> 'driket54/glpi',
            STATUS=> STATUS_OFF,
            NAME=> 'suspicious_dubinsky',
            VMTYPE     => 'docker',
        },
        {
            UUID => '216ff5c60d3e',
            IMAGE=> 'driket54/glpi',
            STATUS=> STATUS_OFF,
            NAME=> 'jolly_jepsen',
            VMTYPE     => 'docker',
        },
        {
            UUID => '22b330476769',
            IMAGE=> 'driket54/glpi',
            STATUS=> STATUS_OFF,
            NAME=> 'lonely_archimedes',
            VMTYPE     => 'docker',
        },
        {
            UUID => '2473dae7d24d',
            IMAGE=> 'driket54/glpi',
            STATUS=> STATUS_OFF,
            NAME=> 'loving_noyce',
            VMTYPE     => 'docker',
        },
        {
            UUID => '982fe8008bbf',
            IMAGE=> 'mariadb:5.5',
            STATUS=> STATUS_OFF,
            NAME=> 'maraidb-5.5-glpi',
            VMTYPE     => 'docker',
        },
        {
            UUID => '5cc66341f6bc',
            IMAGE=> 'driket54/glpi',
            STATUS=> STATUS_OFF,
            NAME=> 'glpiall_glpi_1',
            VMTYPE     => 'docker',
        },
        {
            UUID => 'cdd54d47e939',
            IMAGE=> 'mariadb',
            STATUS=> STATUS_OFF,
            NAME=> 'glpiall_mysql_1',
            VMTYPE     => 'docker',
        },
        {
            UUID => '7756c1009954',
            IMAGE=> 'ef32c3db3aed',
            STATUS=> STATUS_OFF,
            NAME=> 'karaf',
            VMTYPE     => 'docker',
        },
        {
            UUID => '9a7afffcf153',
            IMAGE=> 'postgres:9.4',
            STATUS=> STATUS_OFF,
            NAME=> 'postgresql_karaf',
            VMTYPE     => 'docker',
        },
        {
            UUID => '58bef002b42c',
            IMAGE=> 'jenkins',
            STATUS=> STATUS_OFF,
            NAME=> 'happy_ritchie',
            VMTYPE     => 'docker',
        },
        {
            UUID => 'a0e36958b03c',
            IMAGE=> 'postgres',
            STATUS=> STATUS_OFF,
            NAME=> 'kimios-postgres',
            VMTYPE     => 'docker',
        },
        {
            UUID => 'b98829235592',
            IMAGE=> 'driket54/glpi',
            STATUS=> STATUS_RUNNING,
            NAME=> 'glpi_http',
            VMTYPE     => 'docker',
        },
        {
            UUID => 'f8700da0f53c',
            IMAGE=> 'mariadb:5.5',
            STATUS=> STATUS_OFF,
            NAME=> 'mariadb-glpi',
            VMTYPE     => 'docker',
        }
];

my @containers = GLPI::Agent::Task::Inventory::Virtualization::Docker::_getContainers(
    file => 'resources/containers/docker/docker_ps-a-with-template.sample'
);
my $jsonData = GLPI::Agent::Tools::getAllLines(
    file => 'resources/containers/docker/docker_inspect.json'
);
my $coder = Cpanel::JSON::XS->new->allow_nonref;
my $containersFromJson = $coder->decode($jsonData);
my $containers = {};
for my $cont (@$containersFromJson) {
        my $name = $cont->{Name};
        $name =~ s/^\///;
        $containers->{$name} = $cont;
}
my @containersNew = ();
for my $h (@containers) {
        $h->{STATUS} = GLPI::Agent::Task::Inventory::Virtualization::Docker::_getStatus(
            string => $coder->encode($containers->{$h->{NAME}})
        );
        push @containersNew, $h;
}
cmp_deeply(\@containersNew, $test, 'test _getContainers()');
