CREATE INDEX lang_idx ON public.tweets USING btree (lang);

CREATE INDEX id_tweets_idx ON public.tweets USING btree (id_tweets);

CREATE INDEX text_gin_idx ON public.tweets USING gin (to_tsvector('english'::regconfig, text));

CREATE INDEX tag_idx ON public.tweet_tags USING btree (tag);

