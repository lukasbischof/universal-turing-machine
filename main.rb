#!/usr/bin/env ruby
# frozen_string_literal: true

require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir('lib/')
loader.setup

Main.new.run
