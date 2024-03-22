# File: /main.mk
# Project: python
# File Created: 22-03-2024 12:57:54
# Author: Clay Risser
# -----
# Last Modified: 22-03-2024 14:10:13
# Modified By: Clay Risser
# -----
# BitSpur (c) Copyright 2022 - 2024
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

PYENV ?= pyenv
VENV ?= $(PROJECT_ROOT)/env
PYTHON ?= $(VENV)/bin/python3
PIP ?= $(VENV)/bin/pip3
ifeq ($(VENV)/bin/python3,$(PYTHON))
ACTIVATE := . $(VENV)/bin/activate &&
endif
POETRY ?= $(ACTIVATE) poetry
BLACK ?= $(VENV)/bin/black

ifneq (,$(wildcard $(PROJECT_ROOT)/.tool-versions))
PYTHON_VERSION ?= $(shell $(CAT) $(PROJECT_ROOT)/.tool-versions | $(GREP) -E "^python " | $(CUT) -d' ' -f2)
endif

.PHONY: venv
venv: $(PYTHON)
ifneq (,$(wildcard $(PROJECT_ROOT)/.tool-versions))
$(PYTHON): $(PROJECT_ROOT)/.tool-versions
else
$(PYTHON):
endif
	@if [ "$(PROJECT_ROOT)/.tool-versions" -nt "$(PYTHON)" ]; then \
		$(RM) -rf $(VENV); \
	fi
ifneq (,$(PYTHON_VERSION))
	@export _GLOBAL_PYTHON_VERSION="$$(python3 --version | cut -d' ' -f2)"; \
		if [ "$$_GLOBAL_PYTHON_VERSION" != "$(PYTHON_VERSION)" ]; then \
			$(ECHO) "python version $(PYTHON_VERSION) required but found $$_GLOBAL_PYTHON_VERSION" 1>&2 && \
			exit 1; \
		fi
endif
	@$(WHICH) $(PYTHON) $(NOOUT) || python3 -m venv $(VENV)
	@$(TOUCH) -m $(PYTHON)

.PHONY: python
python: $(VENV)
	@$(PYTHON) $(PYTHON_ARGS)

.PHONY: pip
pip: $(VENV)
	@$(PIP) $(PIP_ARGS)

define poetry_install
if [ pyproject.toml -nt poetry.lock ]; then \
	$(POETRY) lock; \
fi && \
$(POETRY) install --no-root $1
endef
define poetry_install_dev
$(call poetry_install,--with dev $1)
endef

define black_format
$(BLACK) $2 $1
endef

CACHE_ENVS += \
	BLACK \
	PIP \
	POETRY \
	PYENV \
	PYTHON
