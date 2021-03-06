require 'spec_helper'

describe UsdaNutrientDatabase::Import::Downloader do
  let(:downloader) { described_class.new(directory, version) }
  let(:extraction_path) { "#{directory}/#{version}" }
  let(:directory) { 'tmp/usda' }
  let(:version) { 'sr25' }
  let(:filenames) do
    [
      'DATA_SRC.txt', 'DATSRCLN.txt', 'DERIV_CD.txt', 'FD_GROUP.txt',
      'FOOD_DES.txt', 'FOOTNOTE.txt', 'LANGDESC.txt', 'LANGUAL.txt',
      'NUTR_DEF.txt', 'NUT_DATA.txt', 'SRC_CD.txt', 'WEIGHT.txt', 'sr25_doc.pdf'
    ]
  end

  describe '#version_file' do
    subject { downloader.version_file }
    context 'with version sr25' do
      it { is_expected.to eq 'sr25' }
    end
    context 'with version sr27' do
      let(:version) { 'sr27' }
      it { is_expected.to eq 'sr27asc' }
    end
  end

  describe '#download_and_unzip' do
    before do
      stub_request(:get, /.*/).
        to_return(body: File.read('spec/support/sr25.zip'))
      expect(downloader).to receive(:final_path)
        .and_return('/sr25.zip')
      downloader.download_and_unzip
    end

    after { downloader.cleanup }

    it 'should download and extract all files' do
      filenames.each do |filename|
        expect(File.exist?("#{extraction_path}/#{filename}")).to eql(true)
      end
    end
  end

  describe '#cleanup' do
    before do
      stub_request(:get, /.*/).
        to_return(body: File.read('spec/support/sr25.zip'))
      expect(downloader).to receive(:final_path)
        .and_return('/sr25.zip')
      downloader.download_and_unzip
      downloader.cleanup
    end

    it 'should remove all of the extracted files' do
      filenames.each do |filename|
        expect(File.exist?("#{extraction_path}/#{filename}")).to eql(false)
      end
    end
  end
end
