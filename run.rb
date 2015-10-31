require "stripe"
require "twitter"

# Set your secret key: remember to change this to your live secret key in production
# See your keys here https://dashboard.stripe.com/account/apikeys
# Stripe.api_key = "sk_test_lqdgkFtLHJyGlRu6rZUsGqU6"
Stripe.api_key = "sk_live_42HJoCSpSfzcZqA14mXrt3XL"

# Create managed acccount
m = Stripe::Account.create(
  {
    :country => "US",
    :managed => true,
  }
)

account_id = "acct_170mNtGo62Gfy2bv"
#account_id = m[:id]
m_key = m[:keys][:secret]
#print m
#Stripe.api_key = m_key

# Create the product
p = Stripe::Product.create(
    {
      :name => 'Lab',
      :description => 'Super awesome, one-of-a-kind t-shirt',
      # These are the characteristics of the product that SKUs provide values for
      :attributes => ['size', 'gender', 'color'],
      :images => [
        'http://petguide.com.vsassets.com/wp-content/uploads/2013/02/labrador-retriever-2.jpg',
        'http://cutebabywallpapers.com/wp-content/uploads/2015/04/fox_baby_wallpaper.jpg',
        'http://www.critterbabies.com/wp-content/uploads/2014/01/baby-panda-3.jpg']
    },
    {
      :stripe_account => account_id
    }
)

print p[:id]

Stripe::SKU.create(
    {
      :product => p[:id],
      :attributes => {
        'size' => 'Medium',
        'gender' => 'Unisex',
        'color' => 'Cyan',
      },
      :price => 1500,
      :currency => 'usd',
      :inventory => {
        'type' => 'finite',
        'quantity' => 500
      }
    },
    {
      :stripe_account => account_id
    }
)

Stripe::SKU.create(
    {
      :product => p[:id],
      :attributes => {
        'size' => 'Large',
        'gender' => 'Unisex',
        'color' => 'Cyan'
      },
      :price => 1500,
      :currency => 'usd',
      :inventory => {
        'type' => 'finite',
        'quantity' => 400
      }
    },
    {
      :stripe_account => account_id
    }
)

cmd = %{curl -X POST -H "Authorization: Bearer #{ Stripe.api_key }" https://api.stripe.com/v1/products/#{ p[:id] } > response.txt}
p cmd
system(cmd)

tweetable_url = "https://products.stripe.com/twitter/#{ account_id }/products/#{ p[:id] }"
p tweetable_url

config = {
    consumer_key: "jLlkdg8X6PsuZ9mET8DckoA59",
    consumer_secret: "7ArsfKkJ0yQVlKx2WFbVSn7gTcIMw96TNaZBRB2mvLOfzBZzFC",
    access_token: "1161690552-29farTFO2gtPiwXpppRAJFcCzD5x70iBa6TYKbk",
    access_token_secret: "DudE7ssKbtKtRtP39vDloStOsSHy9Ktt1xaVa1EEMejZc"
}

client = Twitter::REST::Client.new(config)
client.update(tweetable_url)
#client.update_with_media(tweetable_url, File.new("/Users/gwchang/Downloads/kitty.jpg"))
