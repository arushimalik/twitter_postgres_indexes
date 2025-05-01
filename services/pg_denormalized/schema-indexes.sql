CREATE INDEX idx_hashtags_combined ON tweets_jsonb
USING gin (
  (
    COALESCE(data->'entities'->'hashtags', '[]') ||
    COALESCE(data->'extended_tweet'->'entities'->'hashtags', '[]')
  )
);

CREATE INDEX idx_text ON public.tweets_jsonb USING gin (
  to_tsvector(
    'english',
    COALESCE((data -> 'extended_tweet' ->> 'full_text'), (data ->> 'text'))
  )
);

CREATE INDEX idx_lang ON tweets_jsonb ((data->>'lang'));

CREATE INDEX idx_tweet_id ON tweets_jsonb ((data->>'id'));
