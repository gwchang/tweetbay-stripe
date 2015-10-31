require "stripe"
require "twitter"
require "oauth2"

api_key = "sk_live_42HJoCSpSfzcZqA14mXrt3XL"
client_id_dev  = "ca_7FWrJkBl8T3QdgieSZ09Ocfx5c9WtxZt"
client_id_prod = "ca_7FWr1LN0ae3c74o6OrgOlU08liLZuwe2"
client_id = client_id_dev

options = {
    :site => 'https://connect.stripe.com',
    :authorize_url => '/oauth/authorize',
    :token_url => '/oauth/token'
}

client = OAuth2::Client.new(client_id, api_key, options)
print client

#cmd = %{curl -X GET https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ client_id }&scope=read_write}
#print cmd + "\n"
#system(cmd)

client_secret = "sk_test_lqdgkFtLHJyGlRu6rZUsGqU6"
code = "ac_7G0FzoaDjCwYf8v0Ls2TSxgKQ5eRItkW"

Stripe.api_key = client_secret

products = Stripe::Product.all
p products

charges = Stripe::Charge.all
p charges

