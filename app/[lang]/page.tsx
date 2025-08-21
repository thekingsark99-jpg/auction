interface PageProps {
  params: {
    lang: string;
  };
}

export default function Page({ params }: PageProps) {
  return (
    <main>
      <h1>Language: {params.lang}</h1>
      {/* Render the rest of your page here */}
    </main>
  );
}

// DO NOT make this async unless you await something!
export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' },
    // Add more supported languages here
  ];
}
