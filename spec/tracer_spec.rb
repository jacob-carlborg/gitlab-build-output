require 'spec_helper'

describe GitLabBuildOutput::Tracer do
  describe 'next_trace' do
    let(:first_trace) { 'foo' }
    let(:second_trace) { first_trace + diff }
    let(:diff) { 'bar' }

    context "when it's the first trace" do
      it 'returns the trace' do
        expect(subject.next_trace(first_trace)).to eq(first_trace)
      end

      context "when it's the second trace" do
        it 'returns the diff compared to the first trace' do
          subject.next_trace(first_trace)
          expect(subject.next_trace(second_trace)).to eq(diff)
        end
      end
    end
  end

  describe 'diff' do
    let(:s1) { 'foo' }
    let(:s2) { s1 + result }
    let(:result) { 'bar' }

    def diff
      subject.send(:diff, s1, s2)
    end

    it 'returns a diff of the two strings' do
      expect(diff).to eq(result)
    end

    context 'when the two strings are the same' do
      let(:s2) { s1 }

      it 'returns an empty string' do
        expect(diff).to be_empty
      end
    end

    context 'when the first string is longer then the second string' do
      let(:s1) { s2 + 'bar' }
      let(:s2) { 'foo' }

      it 'returns nil' do
        expect(diff).to be_nil
      end
    end

    context 'when the first string is nil' do
      let(:s1) { nil }
      let(:s2) { 'foo' }

      it 'returns the second string' do
        expect(diff).to eq(s2)
      end
    end
  end
end
