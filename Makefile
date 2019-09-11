setup:
	git submodule update --init --recursive

gems-install:
	bundle install --path vendor/bundle

docs-gen:
	bundle exec jazzy --config .jazzy.yml --swift-version 5.1 -x USE_SWIFT_RESPONSE_FILE=NO

lib-lint:
	bundle exec pod lib lint

pod-release:
	bundle exec pod trunk push --allow-warnings
