interface PageProps {
  params: {
    lang: string;
  };
}

// This is correct for a server component in Next.js App Router
export default function Page({ params }: PageProps) {
  // You can access the language with params.lang
  return (
    <main>
      <h1>Language: {params.lang}</h1>
      {/* Render the rest of your page here */}
    </main>
  );
}

// This is correct for static generation in App Router
export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' },
    // Add more supported languages here
  ];
}
