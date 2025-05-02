/*
 * Calculates the languages that use the hashtag #coronavirus
 */

SELECT
  data->>'lang' AS lang,
  COUNT(DISTINCT data->>'id') AS count
FROM tweets_jsonb
WHERE (
  COALESCE(data->'entities'->'hashtags', '[]'::jsonb) ||
  COALESCE(data->'extended_tweet'->'entities'->'hashtags', '[]'::jsonb)
) @> '[{"text":"coronavirus"}]'
GROUP BY lang
ORDER BY count DESC, lang;

