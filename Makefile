ANSIBLE_PLAYBOOK := $$HOME/.pyvenv-jajce/bin/ansible-playbook
ANSIBLE_GALAXY := $$HOME/.pyvenv-jajce/bin/ansible-galaxy
PYTHON_ENVIRONMENT := $$HOME/.pyvenv-jajce
tldr:
	@echo Available commands
	@echo ------------------
	@grep '^[[:alpha:]][^:[:space:]]*:' Makefile | cut -d ':' -f 1 | sort -u | sed 's/^/make /'
%:
	@$(MAKE) tldr
ansible:
	python3 -m venv ${PYTHON_ENVIRONMENT}
	source ${PYTHON_ENVIRONMENT}/bin/activate && python3 -m pip install --upgrade pip
	source ${PYTHON_ENVIRONMENT}/bin/activate && python3 -m pip install ansible
	$(ANSIBLE_GALAXY) collection install -r requirements.yml
create:
	 $(ANSIBLE_PLAYBOOK) main.yml -i hosts.ini -e curdir=$(CURDIR)
