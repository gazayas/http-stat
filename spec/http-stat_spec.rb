require 'spec_helper'
require 'http-stat'

# -*- encoding: utf-8 -*-

describe 'http-stat' do
  context 'Test master list' do
    describe 'test -s' do
      # The strings are colorized, so it makes things a little more complicated
      list_re = /(^\e\[0;36;49m100\e\[0m Continue \(Information Response\)\n\e\[0;36;49m101\e\[0m switching protocols)/
      
      # TODO: Refactor so it gets the end of the list too
      #list_re = /(^\e\[0;36;49m100\e\[0m Continue \(Information Response\)\n)($)/

      command 'http-stat -s'
      its(:stdout) { is_expected.to match list_re }
    end
  end

  context 'Test individual statuses' do
    context 'test -s [NUMBER]' do
      describe 'test -s 200' do
        command 'http-stat -s 200'
        its(:stdout) { is_expected.to include("Standard response for succesful HTTP requests.") }
      end

      describe 'test -s 404' do
        command 'http-stat -s 404'
        its(:stdout) {
          is_expected.to include("The requested resource could not be found but may be available in the future.")
        }
      end
    end
  end

  context 'Make sure classifications are accurate' do
    subject{ stat[:number] }
    let(:stat) { stat_ary.first }
    let(:stat_ary) { HttpStat::Statuses.select { |hash| hash[:classification] == classification } }

    describe 'check Information Response' do
      let(:classification) { 'Information Response' }
      it { is_expected.to eq 100 }
    end

    describe 'check Success' do
      let(:classification) { 'Success' }
      it { is_expected.to eq 200 }
    end

    describe 'check Redirection' do
      let(:classification) { 'Redirection' }
      it { is_expected.to eq 300 }
    end

    describe 'check Client Error' do
      let(:classification) { 'Client Error' }
      it { is_expected.to eq 400 }
    end

    describe 'check Server Error' do
      let(:classification) { 'Server Error' }
      it { is_expected.to eq 500 }
    end
  end

  # TODO: This test isn't working
=begin
  context 'Test Japanese' do
    context 'test -s [NUMBER] -jp' do
      subject { its(:stdout) }
      describe 'test -s 200 -jp' do
        command 'http-stat -s 200 -jp'
          # TODO: UTF-8 encoding is apparently incompatible, which is a problem.
          # Not sure if it's just because I'm using the rspec-command gem.
          its(:stdout) { is_expected.to include("OK。リクエストは成功し、レスポンスとともに要求に応じた情報が返される。") }

      end
    end
  end
=end

  context 'Test help' do
    explanation_re = /^A command line tool for looking up the details of http/

    describe 'test -h' do
      command 'http-stat -h'
      its(:stdout) { is_expected.to match explanation_re }
    end

    describe 'test --help' do
      command 'http-stat --help'
      its(:stdout) { is_expected.to match explanation_re }
    end
  end

  context 'Test version' do
    describe 'test -v' do
      command 'http-stat -v'
      its(:stdout) { is_expected.to include(HttpStat::VERSION) }
    end

    describe 'test --version' do
      command 'http-stat --version'
      its(:stdout) { is_expected.to include(HttpStat::VERSION) }
    end
  end
end
