#!/usr/bin/php

<?php

$data = json_decode(file_get_contents('/home/grin/Desktop/grinfit export'), true);
foreach($data as $post)
{
  $title = $post['title'];
  $date = strtotime($post['display_date']);
  $content = $post['body_html'];

  $filename = date('Y-m-d', $date) . '-' . strtolower(preg_replace('/[^A-Za-z0-9]+/', '-',$title)) . '.md';


  $patterns = array(
    '/\<br\s*\/?\>/i', //replace all <br/s> with new lines
    '/\<\/p\s*\>/i',   //append 2 newlines to the end of each </p>
    '/\<\/div\s*\>/i', //append 2 newlines to the end of each </div>
  );
  $replacements = array(
    "\n",
    "</p>\n",
    "</div>\n"
  );

  $content = strip_tags(preg_replace($patterns, $replacements, $content));


  $post = "---\nlayout: post\n---\n\n$title\n" . str_repeat('=',strlen($title)) . "\n\n$content";
  file_put_contents($filename, $post);
}
