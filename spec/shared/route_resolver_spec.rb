require_relative '../../lib/shared/route_resolver'

describe Kirb::RouteValidator do
  it 'wrong route' do
    expect(Kirb::RouteValidator.validate '').to eq(false)
    expect(Kirb::RouteValidator.validate '//').to eq(false)
    expect(Kirb::RouteValidator.validate '/?/').to eq(false)
    expect(Kirb::RouteValidator.validate '/#').to eq(false)
  end

  it 'right route' do
    expect(Kirb::RouteValidator.validate '/').to eq(true)
    expect(Kirb::RouteValidator.validate '/a').to eq(true)
    expect(Kirb::RouteValidator.validate '/aa/b').to eq(true)
    expect(Kirb::RouteValidator.validate '/aa/b/').to eq(true)
    expect(Kirb::RouteValidator.validate '/aa/b/e').to eq(true)
  end
end

describe Kirb::RouteResolver do
  it 'wrong route' do
    expect { Kirb::RouteResolver.new '///' }.to raise_error(Kirb::InvalidRoute)
    expect { Kirb::RouteResolver.new '#/' }.to raise_error(Kirb::InvalidRoute)
    expect { Kirb::RouteResolver.new '#/route' }.to raise_error(Kirb::InvalidRoute)
    expect { Kirb::RouteResolver.new 'GET:#/route' }.to raise_error(Kirb::InvalidRoute)
    expect { Kirb::RouteResolver.new '/GET#/route' }.to raise_error(Kirb::InvalidRoute)
    expect { Kirb::RouteResolver.new '/route///' }.to raise_error(Kirb::InvalidRoute)
    expect { Kirb::RouteResolver.new 'GET#SET#/route/' }.to raise_error(Kirb::InvalidRoute)
  end

  it 'right route' do
    Kirb::RouteResolver.new '//'
    Kirb::RouteResolver.new '/'
    Kirb::RouteResolver.new '/example'
    Kirb::RouteResolver.new '/example/other'
    Kirb::RouteResolver.new '/example/other/'
    Kirb::RouteResolver.new '/:/other'
    Kirb::RouteResolver.new '/:example/hey'
    Kirb::RouteResolver.new '/:example/:hey'
    Kirb::RouteResolver.new ':#/:example/:hey'
    Kirb::RouteResolver.new 'GET#/:example/:hey'
    Kirb::RouteResolver.new ':method#/:example/:hey'
    Kirb::RouteResolver.new ':GET#/route'
    Kirb::RouteResolver.new ':GET#/route//'
  end

  it 'create matcher' do
    match = -> (r) { Kirb::RouteResolver.new(r).matcher.to_s }
    expect(match.('/a/b/c')).to eq(/^([^?\/#:]+#)?\/a\/b\/c$/.to_s)
    expect(match.('/a/b/c/')).to eq(/^([^?\/#:]+#)?\/a\/b\/c\/$/.to_s)
    expect(match.('/a/:b/c/')).to eq(/^([^?\/#:]+#)?\/a\/(?<b>[^?\/#:]+)\/c\/$/.to_s)
    expect(match.('/:/:b/c/')).to eq(/^([^?\/#:]+#)?\/[^?\/#:]+\/(?<b>[^?\/#:]+)\/c\/$/.to_s)
    expect(match.('/:e/d')).to eq(/^([^?\/#:]+#)?\/(?<e>[^?\/#:]+)\/d$/.to_s)
    expect(match.('/:e/d//')).to eq(/^([^?\/#:]+#)?\/(?<e>[^?\/#:]+)\/d(?<*remain*>(\/.*)+)$/.to_s)
  end

  describe 'resolution' do
    resolve = -> (a, b) { Kirb::RouteResolver.new(a).resolve b }
    it 'fail resolve' do
      expect(resolve.('/a/b/c', '/x')).to eq([false, nil, nil])
      expect(resolve.('/:/d', '/x/y')).to eq([false, nil, nil])
      expect(resolve.('/a/b//', '/a/b')).to eq([false, nil, nil])
    end

    it 'resolve' do
      expect(resolve.('//', '/a/b')).to eq([true, {}, '/a/b'])
      expect(resolve.('//', '/a/b/')).to eq([true, {}, '/a/b/'])
      expect(resolve.('/a/b/c', '/a/b/c')).to eq([true, {}, nil])
      expect(resolve.('/a/b/c', '/a/b/c')).to eq([true, {}, nil])
      expect(resolve.('/a/b/c//', '/a/b/c/d')).to eq([true, {}, '/d'])
      expect(resolve.('/a/b//', '/a/b/c/d/e')).to eq([true, {}, '/c/d/e'])
      expect(resolve.('/a/b/c//', '/a/b/c/d')).to eq([true, {}, '/d'])
      expect(resolve.('/:/d', '/x/d')).to eq([true, {}, nil])
      expect(resolve.('/:e/d', '/x/d')).to eq([true, {"e" => "x"}, nil])
      expect(resolve.('/a/:something/:cool//', '/a/test/hey/another/path'))
        .to eq([true, {"something" => "test", "cool" => "hey"}, '/another/path'])
    end

    it 'fail resolve with method' do
      expect(resolve.('POST#/:var/d', 'POST#GET#/avar/d')).to eq([false, nil, nil])
    end

    it 'resolve with method' do
      expect(resolve.('/:e/d', 'GET#/x/d')).to eq([true, {"e" => "x"}, nil])
      expect(resolve.('/:e/d', 'POST#/testing/d')).to eq([true, {"e" => "testing"}, nil])
      expect(resolve.('POST#/:var/d', 'POST#/avar/d')).to eq([true, {"var" => "avar"}, nil])
      expect(resolve.(':#/:e/d', 'GET#/x/d')).to eq([true, {"e" => "x"}, nil])
      expect(resolve.(':var#/:e/d', 'GET#/x/d')).to eq([true, {"var" => "GET", "e" => "x"}, nil])
    end
  end
end