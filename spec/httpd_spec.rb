require 'spec_helper'
require 'httpd'

describe 'httpd' do
  context 'test master list' do
    describe 'test -s' do
      # The strings are colorized, so it makes things a little more complicated
      list_re = /(^\e\[0;36;49m100\e\[0m Continue \(Information Response\)\n\e\[0;36;49m101\e\[0m switching protocols)/
      
      # TODO: Refactor so it gets the end of the list too
      #list_re = /(^\e\[0;36;49m100\e\[0m Continue \(Information Response\)\n)($)/

      command 'httpd -s'
      its(:stdout) { is_expected.to match list_re }
    end
  end

  context 'test individual statuses' do
    context 'test -s [NUMBER]' do
      describe 'test -s 200' do
        command 'httpd -s 200'
        its(:stdout) { is_expected.to include("Standard response for succesful HTTP requests.") }
      end

      describe 'test -s 404' do
        command 'httpd -s 404'
        its(:stdout) {
          is_expected.to include("The requested resource could not be found but may be available in the future.")
        }
      end
    end
  end

  context 'make sure classifications are accurate' do
    subject{ stat[:number] }
    let(:stat) { stat_ary.first }
    let(:stat_ary) { Httpd::Statuses.select { |hash| hash[:classification] == classification } }

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

  context 'test Japanese' do
    describe 'test -s 200 -jp' do
      command 'httpd -s 200 -jp'
      its(:stdout) {
        is_expected.to include("OK。リクエストは成功し、レスポンスとともに要求に応じた情報が返される。")
      }
    end
  end

  context 'test help' do
    explanation_re = /^A command line tool for looking up the details of http/

    describe 'test -h' do
      command 'httpd -h'
      its(:stdout) { is_expected.to match explanation_re }
    end

    describe 'test --help' do
      command 'httpd --help'
      its(:stdout) { is_expected.to match explanation_re }
    end
  end

  context 'test version' do
    describe 'test -v' do
      command 'httpd -v'
      its(:stdout) { is_expected.to include(Httpd::VERSION) }
    end

    describe 'test --version' do
      command 'httpd --version'
      its(:stdout) { is_expected.to include(Httpd::VERSION) }
    end
  end
end
