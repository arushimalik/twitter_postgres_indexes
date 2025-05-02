/*
* Calculates the hashtags that are commonly used with the hashtag #coronavirus
*/

/*
 * Calculates the hashtags that are commonly used with the hashtag #coronavirus
 */

SELECT 
  lower(tag->>'text') AS hashtag,
  COUNT(*) AS count
FROM (
  SELECT 
    jsonb_array_elements(
      COALESCE(data->'entities'->'hashtags','[]') ||
      COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
    ) AS tag
  FROM tweets_jsonb
  WHERE (
    COALESCE(data->'entities'->'hashtags','[]') ||
    COALESCE(data->'extended_tweet'->'entities'->'hashtags','[]')
  ) @> '[{"text":"coronavirus"}]'
) AS hashtags
WHERE lower(tag->>'text') <> 'coronavirus'
GROUP BY hashtag
ORDER BY count DESC;

