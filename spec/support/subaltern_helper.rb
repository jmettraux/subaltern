
module SubalternHelper

  def ruby19?

    RUBY_VERSION.split('.')[0, 2].join('.').to_f > 1.8
  end
end

