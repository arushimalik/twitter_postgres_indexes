/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */

SELECT
  '#' || lower(tag_text) AS tag,
  COUNT(*) AS count
FROM (
  SELECT DISTINCT
    t.data->>'id' AS id_tweets,
    hashtag ->> 'text' AS tag_text
  FROM tweets_jsonb t

  JOIN LATERAL jsonb_array_elements(
    COALESCE(t.data->'entities'->'hashtags', '[]') ||
    COALESCE(t.data->'extended_tweet'->'entities'->'hashtags', '[]')
  ) AS hashtag ON TRUE

  WHERE (
    COALESCE(t.data->'entities'->'hashtags', '[]') ||
    COALESCE(t.data->'extended_tweet'->'entities'->'hashtags', '[]')
  ) @> '[{"text": "coronavirus"}]'

  AND lower(hashtag ->> 'text') <> 'coronavirus'
) AS tag_data
GROUP BY lower(tag_text)
ORDER BY count DESC, tag
LIMIT 1000;

