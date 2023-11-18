# File: /main.mk
# Project: python
# File Created: 17-11-2023 20:57:39
# Author: Clay Risser
# -----
# Last Modified: 17-11-2023 21:08:38
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

PYENV ?= pyenv
VENV ?= $(PROJECT_ROOT)/env
PYTHON ?= $(VENV)/bin/python3
PIP ?= $(VENV)/bin/pip3
ifeq ($(VENV)/bin/python3,$(PYTHON))
ACTIVATE := . $(VENV)/bin/activate &&
endif
POETRY ?= $(ACTIVATE) poetry
BLACK ?= $(VENV)/bin/black

.PHONY: venv
venv: $(PYTHON)
$(PYTHON):
	@$(WHICH) $(PYTHON) $(NOOUT) || python3 -m venv $(VENV)

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
