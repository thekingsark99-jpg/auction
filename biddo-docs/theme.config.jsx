import Image from 'next/image'

export default {
  logo: (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
      <br />
      <Image src="./icon.ico" width={40} height={40} />{' '}
      <span style={{
        fontFamily: "Abril Fatface",
        fontSize: 30,
        marginLeft: 8,
      }}> Biddo </span>
    </div>
  ),
  editLink: {
    text: '',
  },
  feedback: {
    content: '',
  },
  footer: {
    text: '',
  },
  head: (
    <>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="description" content="Introducing our state-of-the-art Mobile Auction App, meticulously crafted with Flutter and powered by a robust NodeJS server. This dynamic application offers a seamless, user-friendly platform for creating and participating in auctions, providing an engaging and secure environment for all your auction needs." />
      <link rel="icon" href="/icon.ico" />

      <link rel="preconnect" href="https://fonts.googleapis.com"/>
      <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin/>
      <link href="https://fonts.googleapis.com/css2?family=Abril+Fatface&display=swap" rel="stylesheet"></link>
      <meta name="google-adsense-account" content="ca-pub-8143251574586070"></meta>
      <style>{`
        body, html, * {
          user-select: text !important;
          -webkit-user-select: text !important; /* For Safari */
        }
        `}
      </style>
    </>
  ),
  useNextSeoProps() {
    return {
      description: 'Biddo ',
      titleTemplate: '%s - Biddo ',
    }
  },
}
