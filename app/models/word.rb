class Word < ApplicationRecord
  acts_as_taggable
  acts_as_favable

  include PublicActivity::Model

  include TitleConverter
  has_paper_trail on: [:update, :destroy]

  validates :title, presence: true

  def self.find(input)
    if input.is_a?(Integer)
      super
    else
      find_by_title(self.param_to_title(input))
    end
  end

  def to_param
    title_to_param
  end

  def self.recent_words(num)
    Word.all.limit(num).order('created_at desc')
  end

  def to_middleman
    <<"EOS"
---
title: #{self.title}
date: #{self.created_at}
tags: #{self.tag_list}
wiki:word_id: #{self.id}
---

#{self.body}
EOS
  end

  after_save do
    Webhook.all.each do |h|
      t = "Word created: <http://localhost:3000/#{self.title} | #{self.title}>"
      c = Faraday.new(h.url)
      c.post('', JSON.generate({text: t}))
    end
  end

end
