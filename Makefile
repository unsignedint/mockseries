PACKAGE_NAME=mockseries
REPO_URL=https://${REPO_BASE}/${INTERNAL_REPO}/

help:            ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/\t/'

install:
	pip install -e .

test-install:
	pip install -r tests/requirements-test.txt

test-check:      ## Check code style
	isort -c --settings-path=tests .
	black --check --config="tests/pyproject.toml" .
	flake8 --config="tests/setup.cfg" .
	pydocstyle --config="tests/setup.cfg" ${PACKAGE_NAME}

test-type:      ## Verify python typing
	mypy -p ${PACKAGE_NAME} --disallow-untyped-defs --disallow-incomplete-defs --no-implicit-optional --no-incremental --config-file="tests/setup.cfg"

test-coverage:  ## Check test coverage
	python -m pytest --cov=${PACKAGE_NAME} tests/

test: test-install test-check test-type test-coverage

test-autofix:      ## Fix style
	isort --settings-path=tests .
	black --config="tests/pyproject.toml" .

prep-package:
	pip install wheel

package:         ## Create python package resources
package: prep-package
	@python setup.py sdist bdist_wheel

doc-dep-install:
	@pip install pydoc-markdown==3.13.0


doc-boostrap:
	@https://github.com/NiklasRosenstein/pydoc-markdown/tree/develop/examples/docusaurus
	@npx @docusaurus/init@latest init docs  classic
	@pydoc-markdown --bootstrap docusaurus

doc:              ## Generate documentation
doc:
	@pydoc-markdown -v
	@echo "Doc generated"

doc-server:          ## Launch a debug doc server
doc-server: doc
	@cd website && npm start

doc2github:
	@echo  "Writing documentation to github pages."
	#todo
	@cp -R html/${PACKAGE_NAME}/ public

