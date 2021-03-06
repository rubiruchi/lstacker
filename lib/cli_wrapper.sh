#!/bin/bash
#
# Copyright 2016-09 brett.chaldecott@gmail.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#
#
# The cli wrapper
#

function cli_execute_command {
	# validate import
	if [ "$#" -ne 2 ]; then
		echo_std_out "Illegal number of parameters"
		echo_std_out "arguments <server> <remote_command>"
		exit -1
	fi

	local server=$1
	local remote_command=$2

	if [ ${server} == "local" ] ; then
		echo_log "${remote_command}"
		local cli_result=`eval ${remote_command}`
		local command_result=$?
		echo "${cli_result}"
		echo_log "Command [${remote_command}]=[${cli_result}]"
		if [ "${IGNORE_RESULTS}" -ne "0" ] && [ ${command_result} -ne 0 ] ; then
			echo_std_out "[cli_execute_command] Failed to execute the command result"
			echo_std_out "${remote_command}"
			exit -1
		fi
		return ${command_result}
	else
		local yaml_ip_var_name="yml_lstack_servers_${server}_ip"
		local yaml_ip_var=${!yaml_ip_var_name}
		if [ -z ${yaml_ip_var} ] ; then
			echo_std_out "[cli_execute_command] failed to retrieve the ip information for ${server}"
			exit -1
		fi
		local ssh_result=`ssh_execute_command "${yaml_ip_var}" "${remote_command}"`
		local command_result=$?
		echo "${ssh_result}"
		return ${command_result}
	fi

}

function cli_execute_command_with_input {
	# validate import
	if [ "$#" -ne 3 ]; then
		echo_std_out "Illegal number of parameters"
		echo_std_out "arguments <server> <remote_command> <input>"
		exit -1
	fi

	local server=$1
	local remote_command=$2
	local input=$3

	if [ ${server} == "local" ] ; then
		echo_log "echo ${input} | eval ${remote_command}"
		local cli_result=`echo "${input}" | eval ${remote_command}`
		local command_result=$?
		echo "${cli_result}"
		if [ "${IGNORE_RESULTS}" -ne "0" ] && [ ${command_result} -ne 0 ] ; then
			echo_std_out "[cli_execute_command] Failed to execute the command result"
			echo_std_out "echo \"${input}\" | ${remote_command}"
			exit -1
		fi
		return ${command_result}
	else
		local yaml_ip_var_name="yml_lstack_servers_${server}_ip"
		local yaml_ip_var=${!yaml_ip_var_name}
		if [ -z "${yaml_ip_var}" ] ; then
			echo_std_out "[cli_execute_command] failed to retrieve the ip information for ${server}"
			exit -1
		fi
		local ssh_result=`ssh_execute_command_with_input "${yaml_ip_var}" "${remote_command}" "${input}"`
		local command_result=$?
		echo "${ssh_result}"
		return ${command_result}
	fi

}

function cli_execute_command_with_file {
	# validate import
	if [ "$#" -ne 3 ]; then
		echo_std_out "[cli_execute_command_with_file]Illegal number of parameters"
		echo_std_out "arguments <server> <remote_command> <file_path>"
		exit -1
	fi

	local server=$1
	local remote_command=$2
	local file_path=$3

	if [ ${server} == "local" ] ; then
		echo_log "cat ${file_path} | eval ${remote_command}"
		local cli_result=`cat "${file_path}" | eval ${remote_command}`
		local command_result=$?
		echo "${cli_result}"
		if [ "${IGNORE_RESULTS}" -ne "0" ] && [ ${command_result} -ne 0 ] ; then
			echo_std_out "[cli_execute_command_with_file] Failed to execute the command result"
			echo_std_out "cat \"${file_path}\" | eval ${remote_command}"
			exit -1
		fi
		return ${command_result}
	else
		local yaml_ip_var_name="yml_lstack_servers_${server}_ip"
		local yaml_ip_var=${!yaml_ip_var_name}
		if [ -z "${yaml_ip_var}" ] ; then
			echo_std_out "[cli_execute_command_with_file] failed to retrieve the ip information for ${server}"
			exit -1
		fi
		local ssh_result=`ssh_execute_command_with_file "${yaml_ip_var}" "${remote_command}" "${file_path}"`
		local command_result=$?
		echo "${ssh_result}"
		return ${command_result}
	fi

}

