every :day do
   rake 'download_and_store:pdfs_from_etsmtl'
   rake 'convert_pdf:to_json'
end
