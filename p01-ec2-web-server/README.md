**Ticket HD-101** from Tunde Bello, Head of Sales
>
> "Investors are visiting on Thursday and I want to show them a live Globaltech web page running on our own cloud server, not a free website builder. It only needs to be a single page for now. Plain HTTP is fine. Also, I want an email if the server is ever working too hard."

**PROMPT**
I have an Amazon Linux 2023 EC2 instance running Apache. Its user data script builds /var/www/html/index.html using IMDSv2 metadata (instance ID, availability zone, public IP).
Write a new bash script named update-page.sh that I will run manually with sudo on the instance. It must:
1. Get an IMDSv2 token, then read instance-id, instance-type, placement/region, placement/availability-zone and public-ipv4.
2. Rebuild index.html for a company called Globaltech with a heading, a short welcome paragraph, and a table showing those five values.
3. Add the current date and time of the update at the bottom of the page.
4. Use only bash and curl, which are already installed.
Add a comment above every block explaining what it does.