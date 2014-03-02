every :day do
   rake 'download_and_store:pdfs_from_etsmtl'
   rake 'convert_pdfs:to_json'
end
