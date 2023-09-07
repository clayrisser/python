# File: /main.mk
# Project: mkpm-python
# File Created: 10-02-2022 10:21:38
# Author: Clay Risser
# -----
# Last Modified: 07-09-2023 07:31:54
# Modified By: Clay Risser
# -----
# Risser Labs (c) Copyright 2022
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

VENV ?= $(PROJECT_ROOT)/env
export BLACK ?= $(VENV)/bin/black
export PIP ?= $(VENV)/bin/pip3
export POETRY ?= poetry
export PYTHON ?= $(VENV)/bin/python3

.PHONY: venv
venv: $(VENV)/bin/python ## create virtual environment
$(VENV)/bin/python:
	@python3 -m venv $(VENV)

.PHONY: python
python: $(VENV) ## run python
	@$(PYTHON) $(PYTHON_ARGS)

.PHONY: pip
pip: $(VENV) ## run pip
	@$(PIP) $(PIP_ARGS)

define poetry_install
if [ pyproject.toml -nt poetry.lock ]; then \
	$(POETRY) lock --no-update; \
fi && \
($(RM) requirements.txt 2>$(NULL) || $(TRUE)) && \
$(POETRY) export $1 -o requirements.txt && \
$(PIP) install -r requirements.txt
endef
define poetry_install_dev
$(call poetry_install,--with dev $1)
endef

define black_lint
$(BLACK) $2 $1
endef

CACHE_ENVS += \
	PIP \
	POETRY \
	PYENV \
	PYTHON
