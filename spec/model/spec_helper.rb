require 'spec_helper'
require 'model/models/basic_model'
require 'model/models/cacheable_model'
require 'model/models/custom_model'
require 'model/models/described_model'
require 'model/models/lazy_model'
require 'model/models/licensed_model'
require 'model/models/named_model'
require 'model/models/titled_model'

RSpec.configure do |spec|
  spec.before(:suite) do
    BasicModel.auto_migrate!
    CacheableModel.auto_migrate!
    CustomModel.auto_migrate!
    DescribedModel.auto_migrate!
    LicensedModel.auto_migrate!
    NamedModel.auto_migrate!
    TitledModel.auto_migrate!
  end
end
