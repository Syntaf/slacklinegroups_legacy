module DevelopHelper
    def hostUrl
        Rails.env.development? ? 'localhost:3000' : 'slacklinegroups.com'
    end
end
