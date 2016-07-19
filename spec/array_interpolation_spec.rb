require 'hiera'

describe 'Array interpolation' do
  let(:datadir) { Dir.mktmpdir }
  let(:hiera) do
    File.open("#{datadir}/main.yaml", 'w') { |f| f.write(yaml) }
    Hiera.new(config: {
                default: nil,
                backends: ['yaml_array'],
                hierarchy: %w(main),
                yaml_array: { datadir: datadir },
                scope: {},
                key: nil,
                verbose: false,
                resolution_type: :priority,
                format: :ruby })
  end

  let(:yaml) do
    { 'array' => '%{foo}', 'string' => 'foo is %{foo}' }.to_yaml
  end

  after(:each) do
    FileUtils.remove_entry(datadir)
  end

  it 'works :-)' do
    expect(hiera.lookup('string', '', 'foo' => %w(hey ho))).to eq('foo is ["hey", "ho"]')
    expect(hiera.lookup('array', '', 'foo' => %w(hey ho))).to eq(%w(hey ho))
  end
end
