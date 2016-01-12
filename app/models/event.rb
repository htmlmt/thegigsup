class Event < ActiveRecord::Base
    belongs_to :venue
    has_and_belongs_to_many :bands
    has_many :reposts
    
    # This method associates the attribute ":avatar" with a file attachment
    has_attached_file :poster, styles: {
        thumb: '100',
        normal: '500',
        retina: '1000'
    }

    # Validate the attached image is image/jpg, image/png, etc
    validates_attachment_content_type :poster, :content_type => /\Aimage\/.*\Z/
end
