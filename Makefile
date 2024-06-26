# File: /Makefile
# Project: python
# File Created: 17-11-2023 21:13:10
# Author: Clay Risser
# -----
# Last Modified: 21-03-2024 14:44:05
# Modified By: Clay Risser
# -----
# BitSpur (c) Copyright 2022 - 2023
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.ONESHELL:
.POSIX:
.SILENT:
.DEFAULT_GOAL := default
MKPM := ./mkpm
.PHONY: default
default:
	@$(MKPM) $(ARGS)
.PHONY: %
%:
	@$(MKPM) "$@" $(ARGS)
