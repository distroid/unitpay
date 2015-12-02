describe Unitpay::Service do
  let(:service) { described_class.new('public_key', 'secret_key', use_sign) }

  let(:sum) { 100 }
  let(:account) { 1 }
  let(:desc) { 'description' }
  let(:valid_sign) { '77e882339ca432b8ad9594b55d33ce59' }
  let(:use_sign) { true }

  describe '#calculate_sign' do
    subject { service.send(:calculate_sign, sum, account, desc) }

    it { is_expected.to eq(valid_sign) }
  end

  describe '#valid_sign?' do
    subject { service.valid_sign?(sign, sum, account, desc) }

    context 'when valid sing' do
      let(:sign) { valid_sign }

      it { is_expected.to be_truthy }
    end

    context 'when invalid sign' do
      let(:sign) { '1' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#valid_notify_sign?' do
    subject { service.valid_notify_sign?(params) }

    let(:params) do
      {
        account: 'test',
        date: '2015-11-29 12:29:00',
        operator: 'mts',
        paymentType: 'mc',
        projectId: '22760',
        phone: '9001234567',
        profit: '9.5',
        sum: amount,
        orderSum: '10.00',
        sign: '22905cade6376990a030b2200f664842',
        orderCurrency: 'RUB',
        unitpayId: '87370'
      }
    end

    context 'when valid' do
      let(:amount) { 10 }

      it { is_expected.to be_truthy }
    end

    context 'when valid' do
      let(:amount) { 11 }

      it { is_expected.to be_falsey }
    end
  end

  describe '#payment_params' do
    let(:options) { {} }
    subject { service.payment_params(sum, account, desc, options) }

    context 'when simple params' do
      it { is_expected.to eq(sum: sum, account: account, desc: desc, sign: valid_sign, currency: 'RUB') }
    end

    context 'when dont use sign' do
      let(:use_sign) { false }

      it { is_expected.to eq(sum: sum, account: account, desc: desc, currency: 'RUB') }
    end

    context 'when set extra params' do
      let(:use_sign) { false }
      let(:options) { { locale: 'ru' } }

      it { is_expected.to eq(sum: sum, account: account, desc: desc, currency: 'RUB', locale: 'ru') }
    end
  end

  describe '#payment_url' do
    subject { service.payment_url(sum, account, desc) }

    it { is_expected.to eq 'https://unitpay.ru/pay/public_key?sum=100&account=1&desc=description&currency=RUB&sign=77e882339ca432b8ad9594b55d33ce59' }
  end
end
