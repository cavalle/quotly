class << self; alias feature describe; end
class << MiniTest::Spec; alias background before; alias scenario it; end
