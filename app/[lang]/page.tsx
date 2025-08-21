interface PageProps {
  params: {
    lang: string;
  };
}

// Do NOT export generateStaticParams after the default export in a file named "page.tsx" in Next.js App Router.
// Instead, place it at the top or above the default export to avoid the type error.
// Also, make sure you are not using `export default generateStaticParams` anywhere.

export function generateStaticParams() {
  return [
    { lang: 'en' },
    { lang: 'fr' },
    { lang: 'es' },
    // Add more supported languages here
  ];
}

export default function Page({ params }: PageProps) {
  return (
    <main>
      <h1>Language: {params.lang}</h1>
      {/* Render the rest of your page here */}
    </main>
  );
}
