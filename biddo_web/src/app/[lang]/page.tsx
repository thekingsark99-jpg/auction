interface PageProps {
  params: {
    lang: string;
  };
}

export default function Page({ params }: PageProps) {
  // You can access the language with params.lang
  return (
    <main>
      <h1>Language: {params.lang}</h1>
      {/* Render the rest of your page here */}
    </main>
  );
}

// If you want to statically generate for multiple languages:
export async function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' },
    // Add more supported languages here
  ];
}
